module Page.Top exposing (Model, Msg(..), init, update, view)

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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ viewSideBar
        , div [ id "top-page" ] [ viewContainer ]
        ]


viewContainer : Html Msg
viewContainer =
    div [ class "top-page-container" ]
        [ a [ href "#" ] [ text "学習を始める" ]
        , p [] [ text "学習すべきカード" ]
        , div [] [ text "新しいカード" ]
        , div [] [ text "復習すべきカード" ]
        , div [ class "footer-button" ]
            [ a [ href "#" ] [ text "学習カードを追加" ]
            ]
        ]


viewSideBar : Html Msg
viewSideBar =
    div [ id "sidebar" ]
        [ div [ class "sidebar-menue" ]
            [ ul []
                [ li [] [ a [ href "#" ] [ text "カードを編集" ] ]
                , li [] [ a [ href "#" ] [ text "学習記録" ] ]
                , li [] [ a [ href "#" ] [ text "設定" ] ]
                , li [] [ a [ href "#" ] [ text "ヘルプ" ] ]
                , li [] [ a [ href "#" ] [ text "ログアウト" ] ]
                , li [] [ a [ href "#" ] [ text "要望" ] ]
                , a [ href "https://twitter.com/intent/tweet?text=%E3%82%A2%E3%83%B3%E3%82%AD%E3%83%91%E3%83%B3%E3%81%A0%E3%81%8A", target "_bulk" ] [ text "ツイート" ]
                ]
            ]
        ]
