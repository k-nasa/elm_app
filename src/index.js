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

app.ports.cacheCards.subscribe(function(cards) {
  localStorage.setItem(storageKeyCards, JSON.stringify(cards));
});

app.ports.clearLocalStorageUid.subscribe(function() {
  localStorage.removeItem(storageKeyToken);

  location.reload();
});

// app.ports.getUid.subscribe(function() {
//   let uid = localStorage.getItem(storageKeyUid);
//   app.port.receiveUid.send(uid);
// });

app.ports.getCachedCards.subscribe(function() {
  let cards = JSON.parse(localStorage.getItem(storageKeyCards));

  app.ports.receiveCachedCards.send(cards);
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

    let token = await response.json().token;

    window.localStorage.setItem(storageKeyToken, token);
    app.ports.receivedLoggedIn.send(null);
  }

  app.ports.loading.send(false);
}
