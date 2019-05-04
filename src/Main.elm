module Main exposing (init, main, subscriptions)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (Model, Page(..))
import Page.Login
import Page.Top
import Port exposing (loading, receiveCachedCards, receivedLoggedIn)
import Route exposing (Route, parse)
import Update exposing (Msg(..), goTo, redirectSignUpPage, redirectTopPage, update)
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
            Model NotFound key False
                |> goTo (Route.parse url)

        False ->
            Model NotFound key False
                |> redirectSignUpPage


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ receivedLoggedIn ReceivedLoggedIn
        , loading Loading
        , receiveCachedCards ReceivedCachedCards
        ]
