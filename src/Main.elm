module Main exposing (init, main, subscriptions)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (Model, Page(..))
import Page.Login
import Page.Top
import Port exposing (loading, receivedLoggedIn)
import Route exposing (Route, parse)
import Update exposing (Msg(..), redirectSignUpPage, redirectTopPage, update)
import Url exposing (Url)
import View exposing (view)


main : Program Bool Model Msg
main =
    Browser.application
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }


init : Bool -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    case flags of
        True ->
            -- どうせgoToでmodel.pageは書き換わるのでNotFoundで仮置き
            Model NotFound key False
                |> redirectTopPage

        False ->
            -- どうせredirectSignUpPageでmodel.pageは書き換わるのでNotFoundで仮置き
            Model NotFound key False
                |> redirectSignUpPage


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ receivedLoggedIn ReceivedLoggedIn
        , loading Loading
        ]
