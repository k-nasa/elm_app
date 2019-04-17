module Page.AddCard exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (class, cols, href, id, placeholder, rows, type_)
import Html.Events exposing (..)
import Port


init : Model
init =
    {}


type alias Model =
    { questionText : String
    , answerText : String
    , memo : String
    , errors : Errors
    }

    }


type Msg
    = Submit
    | InputQuestion String
    | InputAnswer String
    | InputMemo String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div [ id "add-card-page" ]
        [ form [ class "card-form", onSubmit Submit ]
            [ div [ class "form-header" ]
                [ button [ class "lerge-plus-button" ]
                    [ i [ class "fas fa-plus" ] []
                    , text "学習カードを追加"
                    ]
                , a [ href "/", class "close-button" ]
                    [ i [ class "fas fa-times" ] []
                    ]
                ]
            , div [ class "form-group" ]
                [ div [ class "card-form-item" ]
                    [ div [ class "form-item" ]
                        [ label [ class "form-caption" ] [ text "問題文" ]
                        , textarea [ class ("form-control " ++ hasError model.errors.questionText), placeholder "問題文を入力してください", onInput InputQuestion, value model.questionText ] []
                        , div [ class "invalid-feedback" ] [ text model.errors.questionText ]
                        ]
                    ]
                , div [ class "card-form-item" ]
                    [ div [ class "form-item" ]
                        [ label [ class "form-caption" ] [ text "回答文" ]
                        , textarea [ class ("form-control " ++ hasError model.errors.answerText), placeholder "答えを入力してください", onInput InputAnswer, value model.answerText ] []
                        , div [ class "invalid-feedback" ] [ text model.errors.answerText ]
                        ]
                    ]
                , div [ class "card-form-item" ]
                    [ div [ class "form-item" ]
                        [ input [ class "form-control", type_ "text", placeholder "メモ", onInput InputMemo, value model.memo ] []
                        ]
                    ]
                ]
            ]
        ]
