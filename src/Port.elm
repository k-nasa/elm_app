port module Port exposing (signInWithGitHub, signInWithGoogle)


port signInWithGoogle : () -> Cmd msg


port signInWithGitHub : () -> Cmd msg


port receivedLoggedIn : (() -> msg) -> Sub msg

