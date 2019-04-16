module Model exposing (Model, Page(..))

import Browser.Navigation as Nav
import Page.Login
import Page.Top


type Page
    = NotFound
    | TopPage Page.Top.Model
    | AboutPage
    | LoginPage Page.Login.Model


type alias Model =
    { page : Page
    , key : Nav.Key
    , loading : Bool
    }
