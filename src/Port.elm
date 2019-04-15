port module Port exposing (loading, receivedLoggedIn, signInWithGitHub, signInWithGoogle)


port signInWithGoogle : () -> Cmd msg


port signInWithGitHub : () -> Cmd msg


port receivedLoggedIn : (() -> msg) -> Sub msg


port loading : (Bool -> msg) -> Sub msg
