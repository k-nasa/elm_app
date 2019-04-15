import firebase from 'firebase';

export function signInWithGoogle() {
  var provider = new firebase.auth.GoogleAuthProvider();
  loginWithFirebase(provider);
}

export function signInWithGithub() {
  var provider = new firebase.auth.GithubAuthProvider();
  loginWithFirebase(provider);
}

export function init() {
  var config = {
    apiKey: 'AIzaSyAegecZa_YUxsqJdkjVIIm1FOcZiW66EWw',
    authDomain: 'ankipan-8f2bf.firebaseapp.com',
    databaseURL: 'https://ankipan-8f2bf.firebaseio.com',
    projectId: 'ankipan-8f2bf',
    storageBucket: 'ankipan-8f2bf.appspot.com',
    messagingSenderId: '696406223655',
  };
  firebase.initializeApp(config);
}

export function fetchFirebaseRedirectResult() {
  firebase
    .auth()
    .getRedirectResult()
    .then(function(result) {
      if (result.credential) {
        var token = result.credential.accessToken;
      }
      var uid = result.user.uid;
      console.log(uid);

      localStorage.setItem('uid', uid);
    })
    .catch(function(error) {});
}

function loginWithFirebase(provider) {
  firebase.auth().signInWithRedirect(provider);
}
