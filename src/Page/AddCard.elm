module Page.AddCard exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (class, cols, href, id, placeholder, rows, type_)
import Html.Events exposing (..)
import Port


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
    div [ id "add-card-page" ]
        [ form [ class "card-form", onClick NoOp ]
            [ div [ class "form-header" ]
                [ button [ class "lerge-plus-button" ]
                    [ i [ class "fas fa-plus" ] []
                    , text "学習カードを追加"
                    ]
                , a [ href "/", class "close-button" ]
                    [ i [ class "fas fa-times" ] []
                    ]
                ]
            , div [ class "card-form-item" ]
                [ p [ class "form-caption" ] [ text "問題文" ]
                , textarea [ class "form-control", placeholder "問題文を入力してください" ] []
                ]
            , div [ class "card-form-item" ]
                [ p [ class "form-caption" ] [ text "回答文" ]
                , textarea [ class "form-control", placeholder "答えを入力してください" ] []
                ]
            , div [ class "card-form-item" ]
                [ input [ class "form-control", type_ "text", placeholder "メモ" ] []
                ]
            ]
        ]
