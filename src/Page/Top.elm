module Page.Top exposing (Model, Msg(..), init, update, view)

import Components.Loading exposing (loadingView)
import Data.Card exposing (Card, cardCountTuple, cardsDecoder, dummyCard)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Port exposing (cacheCards)


init : ( Model, Cmd Msg )
init =
    ( { loading = Loading
      , cards = [ dummyCard, dummyCard ]
      }
    , fetchCards
    )


type alias Model =
    { loading : LoadStatus
    , cards : List Card
    }


type LoadStatus
    = Loading
    | LoadedCards (List Card)
    | Failed Http.Error


type Msg
    = Receive (Result Http.Error (List Card))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Receive (Ok cards) ->
            ( { model | loading = LoadedCards [], cards = cards }, cacheCards cards )

        -- FIXME api未実装のためここでcacheCardsを呼び出す
        Receive (Err e) ->
            ( { model | loading = Failed e }, cacheCards model.cards )


fetchCards : Cmd Msg
fetchCards =
    Http.get
        { url = "http://localhost:8080/graphiql"
        , expect = Http.expectJson Receive cardsDecoder
        }


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

        -- FIXME エラー画面を表示すべきだがAPI未実装なので仮置き
        Failed e ->
            div []
                [ text "エラーが起きました。スミマセンorz"
                , content
                ]

        LoadedCards c ->
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
