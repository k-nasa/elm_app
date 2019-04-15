module Page.Login exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Port


init : Model
init =
    {}


type alias Model =
    {}


type Msg
    = NoOp
    | SignInWithGoogle
    | SignInWithGithub


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SignInWithGoogle ->
            ( model, Port.signInWithGoogle () )

        SignInWithGithub ->
            ( model, Port.signInWithGitHub () )

        NoOp ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ ul []
            [ li []
                [ button [ class "fa fa-facebook" ] [ text "Facebookログイン" ]
                , button [ class "fa fa-twitter" ] [ text "Twitterログイン" ]
                , button [ onClick SignInWithGithub, class "fa fa-github" ] [ text "GitHubログイン" ]
                , button [ onClick SignInWithGoogle, class "fa fa-github" ] [ text "Googleログイン" ]
                ]
            ]
        ]
