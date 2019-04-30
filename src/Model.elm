module Model exposing (Model, Page(..))

import Browser.Navigation as Nav
import Page.AddCard
import Page.Login
import Page.Question
import Page.Top


type Page
    = NotFound
    | TopPage Page.Top.Model
    | AboutPage
    | LoginPage Page.Login.Model
    | AddCardPage Page.AddCard.Model
    | QuestionPage Page.Question.Model


type alias Model =
    { page : Page
    , key : Nav.Key
    , loading : Bool
    }
