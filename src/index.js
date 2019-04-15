import './main.css';
import {Elm} from './Main.elm';
import registerServiceWorker from './registerServiceWorker';
import * as F from './firebase';

const storageKey = 'uid';
const getUidByStorage = storageKey => localStorage.getItem(storageKey);

var loggedIn = getUidByStorage(storageKey) !== null;
F.init();

if (!loggedIn) {
  F.fetchFirebaseRedirectResult();
}

const app = Elm.Main.init({
  flags: loggedIn,
  node: document.getElementById('root'),
});

console.log(app);
app.ports.signInWithGoogle.subscribe(function() {
  F.signInWithGoogle();
});

app.ports.signInWithGitHub.subscribe(function() {
  F.signInWithGithub();
});

registerServiceWorker();
