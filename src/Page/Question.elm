module Page.Question exposing (Model, Msg(..), init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)



-- TODO apiサーバーからcardsを取ってくる必要あり
-- ダミーで仮置き


init : Model
init =
    { question_count = 6
    , solved_count = 0
    , does_show_answer = False
    , remaining_cards =
        [ dummyCard
        , dummyCard
        , dummyCard
        , dummyCard
        ]
    }


type alias Model =
    { question_count : Int
    , solved_count : Int
    , remaining_cards : List Card
    , does_show_answer : Bool
    }


type Msg
    = NoOp
    | ShowAnswer


type alias Card =
    { id : Int
    , user_id : Int
    , problem_statement : String
    , answer_text : String
    , memo : String
    , question_time : String
    }


dummyCard : Card
dummyCard =
    { id = 1
    , user_id = 1
    , problem_statement = "問題文。長いお~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    , answer_text = "回答文だお"
    , memo = "メモ"
    , question_time = "分からん"
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ShowAnswer ->
            ( { model | does_show_answer = True }, Cmd.none )


view : Model -> Html Msg
view model =
    div [ id "question-page" ]
        [ questionNavBar
        , div [ class "form-header" ]
            [ div [ class "question-card-container" ]
                [ p [ class "question-card-header" ]
                    [ span [ class "card-title" ]
                        [ text "問題" ]
                    , span [ class "question-percentage" ]
                        [ text
                            (String.fromInt (model.solved_count + 1)
                                ++ "/"
                                ++ String.fromInt model.question_count
                            )
                        ]
                    ]
                , div [ class "question-card-content" ]
                    [ p [ class "question-text" ]
                        [ text
                            (case List.head model.remaining_cards of
                                Just card ->
                                    card.problem_statement

                                Nothing ->
                                    ""
                            )
                        ]
                    ]
                ]
            , if model.does_show_answer then
                text "show!!"

              else
                p [ class "lerge-plus-button", href "#", onClick ShowAnswer ]
                    [ i [ class "fas fa-laptop-code" ] []
                    , text "答えを確認"
                    ]
            ]
        ]


questionNavBar : Html Msg
questionNavBar =
    div [ class "question-nav-bar bg-light" ]
        [ nav [ class "navbar navbar-expand-lg navbar-light" ]
            [ a [ class "navbar-brand back-button", href "/" ]
                [ i [ class "fas fa-arrow-left" ] []
                ]
            ]
        ]
