module Page.Question exposing (Model, Msg(..), init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


init : Model
init =
    {}


type alias Model =
    {}


type Msg
    = NoOp


type alias Card =
    { id : Int
    , user_id : Int
    , problem_statement : String
    , answer_text : String
    , memo : String
    , question_time : String
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( {}, Cmd.none )


view : Model -> Html Msg
view model =
    div [] []
