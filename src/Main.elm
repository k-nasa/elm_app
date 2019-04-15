module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Page.Login
import Route exposing (Route, parse)
import Url exposing (Url)


main : Program Bool Model Msg
main =
    Browser.application
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }


init : Bool -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    case flags of
        True ->
            -- どうせgoToでmodel.pageは書き換わるのでNotFoundで仮置き
            Model NotFound key
                |> goTo (Route.parse url)

        False ->
            -- どうせredirectSignUpPageでmodel.pageは書き換わるのでNotFoundで仮置き
            Model NotFound key
                |> redirectSignUpPage



---- MODEL ----


type Page
    = NotFound
    | TopPage
    | AboutPage
    | LoginPage Page.Login.Model


type alias Model =
    { page : Page
    , key : Nav.Key
    }



---- UPDATE ----


type Msg
    = NoOp
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | LoginMsg Page.Login.Msg
    | ReceivedLoggedIn ()


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            goTo (Route.parse url) model

        LoginMsg loginMsg ->
            case model.page of
                LoginPage loginModel ->
                    let
                        ( newTopModel, topCmd ) =
                            Page.Login.update loginMsg loginModel
                    in
                    ( { model | page = LoginPage newTopModel }
                    , Cmd.map LoginMsg topCmd
                    )

                _ ->
                    ( model, Cmd.none )

        ReceivedLoggedIn _ ->
            redirectTopPage model

        NoOp ->
            ( model, Cmd.none )


goTo : Maybe Route -> Model -> ( Model, Cmd Msg )
goTo maybeRoute model =
    case maybeRoute of
        Nothing ->
            ( { model | page = NotFound }, Cmd.none )

        Just Route.Top ->
            ( { model | page = TopPage }
            , Cmd.none
            )

        Just Route.About ->
            ( { model | page = AboutPage }, Cmd.none )

        Just Route.Login ->
            ( { model | page = LoginPage Page.Login.init }, Cmd.none )


redirectSignUpPage : Model -> ( Model, Cmd Msg )
redirectSignUpPage model =
    ( model, Nav.pushUrl model.key "sign_up" )


redirectTopPage : Model -> ( Model, Cmd Msg )
redirectTopPage model =
    ( model, Nav.pushUrl model.key "top" )



---- VIEW ----


view : Model -> Browser.Document Msg
view model =
    { title = "ankipan"
    , body =
        [ case model.page of
            LoginPage loginModel ->
                Page.Login.view loginModel
                    |> Html.map LoginMsg

            _ ->
                text "unimplement"
        ]
    }
