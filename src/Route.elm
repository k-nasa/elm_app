module Route exposing (Route(..), parse)

import Url exposing (Url)
import Url.Parser exposing (..)


type Route
    = Top
    | About
    | Login


parse : Url -> Maybe Route
parse url =
    Url.Parser.parse parser url


parser : Parser (Route -> a) a
parser =
    oneOf
        [ map Top top
        , map About (s "about")
        , map Login (s "login")
        , map Login (s "sign_up")
        ]
