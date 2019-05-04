import './main.css';
import {Elm} from './Main.elm';
import registerServiceWorker from './registerServiceWorker';
import * as F from './firebase';

registerServiceWorker();
const storageKeyUid = 'uid';
const storageKeyCards = 'cards';

const getUidByStorage = () => localStorage.getItem(storageKeyUid);

var loggedIn = getUidByStorage() !== null;
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
  localStorage.removeItem(storageKeyUid);

  location.reload();
});

async function fetchRedirectResult() {
  app.ports.loading.send(true);
  const result = await F.fetchFirebaseRedirectResult();

  if (result.credential) {
    var token = result.credential.accessToken;
    var uid = result.user.uid;
    window.localStorage.setItem(storageKeyUid, uid);
    app.ports.receivedLoggedIn.send(null);
  }

  app.ports.loading.send(false);
}
