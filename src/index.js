import './main.css';
import {Elm} from './Main.elm';
import registerServiceWorker from './registerServiceWorker';
import * as F from './firebase';

registerServiceWorker();

const storageKeyToken = 'token';
const storageKeyCards = 'cards';

const getTokenByStorage = () => localStorage.getItem(storageKeyToken);

var loggedIn = getTokenByStorage() !== null;
F.init();

const app = Elm.Main.init({
  flags: loggedIn,
});

if (!loggedIn) {
  fetchRedirectResult();
}

app.ports.signInWithGoogle.subscribe(function() {
  F.signInWithGoogle();
});

app.ports.signInWithGitHub.subscribe(function() {
  F.signInWithGithub();
});

// app.ports.cacheCards.subscribe(function(cards) {
//   localStorage.setItem(storageKeyCards, JSON.stringify(cards));
// });

app.ports.clearLocalStorageUid.subscribe(function() {
  localStorage.removeItem(storageKeyToken);

  location.reload();
});

app.ports.getCachedCards.subscribe(function() {
  let cards = JSON.parse(localStorage.getItem(storageKeyCards));

  app.ports.receiveCachedCards.send(cards);
});

app.ports.fetchCards.subscribe(function() {
  let token = localStorage.getItem(storageKeyToken);

  fetch('http://localhost:8080/cards?token=' + token, {
    method: 'GET',
    mode: 'cors',
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
    },
  })
    .then(function(response) {
      return response.json();
    })
    .then(function(json) {
      localStorage.setItem(storageKeyCards, JSON.stringify(json));

      let cards = JSON.parse(localStorage.getItem(storageKeyCards));
      app.ports.receiveCachedCards.send(cards);
    });
});

async function fetchRedirectResult() {
  app.ports.loading.send(true);
  const result = await F.fetchFirebaseRedirectResult();

  if (result.credential) {
    let uid = result.user.uid;

    let user_params = {
      uid: uid,
      name: 'name',
      email: 'example.com',
    };

    let response = await fetch('http://localhost:8080/user', {
      method: 'POST',
      mode: 'cors',
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: JSON.stringify(user_params),
    });

    let token = await response.json();

    window.localStorage.setItem(storageKeyToken, token['token']);
    app.ports.receivedLoggedIn.send(null);
  }

  app.ports.loading.send(false);
}
