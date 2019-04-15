import './main.css';
import {Elm} from './Main.elm';
import registerServiceWorker from './registerServiceWorker';
import * as F from './firebase';

registerServiceWorker();
const storageKey = 'uid';
const getUidByStorage = storageKey => localStorage.getItem(storageKey);

var loggedIn = getUidByStorage(storageKey) !== null;
F.init();

const app = Elm.Main.init({
  flags: loggedIn,
  node: document.getElementById('root'),
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

async function fetchRedirectResult() {
  app.ports.loading.send(true);
  const result = await F.fetchFirebaseRedirectResult();

  if (result.credential) {
    var token = result.credential.accessToken;
    var uid = result.user.uid;
    window.localStorage.setItem('uid', uid);
    app.ports.receivedLoggedIn.send(null);
  }

  app.ports.loading.send(false);
}
