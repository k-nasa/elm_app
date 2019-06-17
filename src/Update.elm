module Update exposing (Msg(..), goTo, redirectSignUpPage, redirectTopPage, update)

import Browser
import Browser.Navigation as Nav
import Data.Card exposing (LoadStatus(..))
import Model exposing (Model, Page(..))
import Page.AddCard
import Page.Login
import Page.Question
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
    | AddCardMsg Page.AddCard.Msg
    | QuestionMsg Page.Question.Msg
    | ReceivedLoggedIn ()
    | ReceivedCachedCards Data.Card.Cards
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

        AddCardMsg pageMsg ->
            case model.page of
                AddCardPage pageModel ->
                    let
                        ( newModel, cmd ) =
                            Page.AddCard.update pageMsg pageModel
                    in
                    ( { model | page = AddCardPage newModel }
                    , Cmd.map AddCardMsg cmd
                    )

                _ ->
                    ( model, Cmd.none )

        QuestionMsg pageMsg ->
            case model.page of
                QuestionPage pageModel ->
                    let
                        ( newModel, cmd ) =
                            Page.Question.update pageMsg pageModel
                    in
                    ( { model | page = QuestionPage newModel }
                    , Cmd.map QuestionMsg cmd
                    )

                _ ->
                    ( model, Cmd.none )

        ReceivedLoggedIn _ ->
            redirectTopPage model

        ReceivedCachedCards cards ->
            case model.page of
                TopPage pageModel ->
                    ( { model
                        | page =
                            TopPage
                                { pageModel
                                    | loading = LoadedCards
                                }
                      }
                    , Cmd.none
                    )

                QuestionPage pageModel ->
                    ( { model
                        | page =
                            QuestionPage
                                { pageModel
                                    | remaining_cards = cards
                                    , question_count = List.length cards
                                }
                      }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )

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
            let
                ( topPageModel, cmd ) =
                    Page.Top.init
            in
            ( { model | page = TopPage topPageModel }, Cmd.map TopMsg cmd )

        Just Route.About ->
            ( { model | page = AboutPage }, Cmd.none )

        Just Route.AddCard ->
            ( { model | page = AddCardPage Page.AddCard.init }, Cmd.none )

        Just Route.Login ->
            ( { model | page = LoginPage Page.Login.init }, Cmd.none )

        Just Route.Question ->
            let
                ( questionPageModel, cmd ) =
                    Page.Question.init model.key
            in
            ( { model | page = QuestionPage questionPageModel }, Cmd.map QuestionMsg cmd )


redirectSignUpPage : Model -> ( Model, Cmd Msg )
redirectSignUpPage model =
    ( model, Nav.pushUrl model.key "sign_up" )


redirectTopPage : Model -> ( Model, Cmd Msg )
redirectTopPage model =
    ( model, Nav.pushUrl model.key "/" )
