port module Port exposing
    ( cacheCards
    , clearLocalStorageUid
    , getCachedCards
    , loading
    , receiveCachedCards
    , receivedLoggedIn
    , signInWithGitHub
    , signInWithGoogle
    )

import Data.Card exposing (Cards)


port signInWithGoogle : () -> Cmd msg


port signInWithGitHub : () -> Cmd msg


port clearLocalStorageUid : () -> Cmd msg


port receivedLoggedIn : (() -> msg) -> Sub msg


port loading : (Bool -> msg) -> Sub msg


port cacheCards : Cards -> Cmd msg


port receiveCachedCards : (Cards -> msg) -> Sub msg


port getCachedCards : () -> Cmd msg
