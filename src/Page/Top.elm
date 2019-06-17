module Page.Top exposing (Model, Msg(..), init, update, view)

import Components.Loading exposing (loadingView)
import Data.Card exposing (Card, LoadStatus(..), cardCountTuple, cardsDecoder, dummyCard)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Port exposing (cacheCards, fetchCards)


init : ( Model, Cmd Msg )
init =
    ( { loading = Loading
      , cards = [ dummyCard, dummyCard ]
      }
    , fetchCards ()
    )


type alias Model =
    { loading : LoadStatus
    , cards : List Card
    }


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    viewLoading model
        (div
            [ class "container" ]
            [ div [ id "top-page" ] [ viewContainer model ]
            ]
        )


viewLoading : Model -> Html msg -> Html msg
viewLoading model content =
    case model.loading of
        Loading ->
            loadingView

        LoadedCards ->
            content


viewContainer : Model -> Html Msg
viewContainer model =
    let
        ( unsolve_count, solved_count ) =
            cardCountTuple model.cards
    in
    div []
        [ div [ class "top-page-container" ]
            [ a [ class "lerge-start-button", href "/question" ]
                [ i [ class "fas fa-laptop-code" ] []
                , text "学習を始める"
                ]
            , p [ class "sub-caption" ] [ text "学習すべきカード" ]
            , div [ class "card-description" ]
                [ div [ class "new-card-container" ]
                    [ p [ class "caption" ]
                        [ text "新しい"
                        , br [] []
                        , text "カード"
                        ]
                    , p [ class "number" ] [ text (String.fromInt unsolve_count) ]
                    ]
                , div [ class "review-card-container" ]
                    [ p [ class "caption" ]
                        [ text "復習すべき"
                        , br [] []
                        , text "カード"
                        ]
                    , p [ class "number" ] [ text (String.fromInt solved_count) ]
                    ]
                ]
            ]
        , div [ class "footer-button" ]
            [ a [ href "/add_card", class "lerge-plus-button" ]
                [ i [ class "fas fa-plus" ] []
                , text "学習カードを追加"
                ]
            ]
        ]
