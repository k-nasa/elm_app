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
    div [ class "social-buttons" ]
        [ li []
            [ button [ class "btn btn-outline-dark", onClick SignInWithGoogle ]
                [ img [ src "%PUBLIC_URL%/assets/images/google-logo.png", width 18, height 18 ] []
                , text "Googleログイン"
                ]
            ]
        , li []
            [ button [ class "btn btn-outline-dark" ]
                [ img [ src "%PUBLIC_URL%/assets/images/twitter-logo.png", width 18, height 18 ] []
                , text "Twitterログイン"
                ]
            ]
        , li []
            [ button [ class "btn btn-outline-dark", onClick SignInWithGithub ]
                [ img [ src "%PUBLIC_URL%/assets/images/github-logo.png", width 18, height 18 ] []
                , text "GitHubログイン"
                ]
            ]
        ]
