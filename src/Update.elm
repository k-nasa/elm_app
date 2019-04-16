module Update exposing (Msg(..), redirectSignUpPage, redirectTopPage, update)

import Browser
import Browser.Navigation as Nav
import Model exposing (Model, Page(..))
import Page.Login
import Page.Top
import Port exposing (clearLocalStorageUid)
import Route exposing (Route)
import Url


type Msg
    = NoOp
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | LoginMsg Page.Login.Msg
    | TopMsg Page.Top.Msg
    | ReceivedLoggedIn ()
    | Loading Bool
    | ClearLocalStorageUid


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

        TopMsg pageMsg ->
            case model.page of
                TopPage pageModel ->
                    let
                        ( newModel, cmd ) =
                            Page.Top.update pageMsg pageModel
                    in
                    ( { model | page = TopPage newModel }
                    , Cmd.map TopMsg cmd
                    )

                _ ->
                    ( model, Cmd.none )

        ReceivedLoggedIn _ ->
            redirectTopPage model

        ClearLocalStorageUid ->
            ( model, Port.clearLocalStorageUid () )

        NoOp ->
            ( model, Cmd.none )

        Loading bool ->
            ( { model | loading = bool }, Cmd.none )


goTo : Maybe Route -> Model -> ( Model, Cmd Msg )
goTo maybeRoute model =
    case maybeRoute of
        Nothing ->
            ( { model | page = NotFound }, Cmd.none )

        Just Route.Top ->
            ( { model | page = TopPage Page.Top.init }, Cmd.none )

        Just Route.About ->
            ( { model | page = AboutPage }, Cmd.none )

        Just Route.Login ->
            ( { model | page = LoginPage Page.Login.init }, Cmd.none )


redirectSignUpPage : Model -> ( Model, Cmd Msg )
redirectSignUpPage model =
    ( model, Nav.pushUrl model.key "sign_up" )


redirectTopPage : Model -> ( Model, Cmd Msg )
redirectTopPage model =
    ( model, Nav.pushUrl model.key "/" )
