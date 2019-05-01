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
    }


type Msg
    = NoOp


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


view : Model -> Html Msg
view model =
    div []
        [ div [ class "form-header" ]
            [ a [ href "/", class "close-button" ]
                [ i [ class "fas fa-times" ] []
                ]
            , div [ class "question-card-container" ]
                [ div [ class "question-card-header" ]
                    [ span [ class "question-percentage" ]
                        [ text (String.fromInt model.solved_count ++ "/" ++ String.fromInt model.question_count)
                        ]
                    , span [ class "card-title" ]
                        [ text "問題文"
                        ]
                    ]
                , div [ class "question-card-content" ]
                    [ text
                        (case List.head model.remaining_cards of
                            Just card ->
                                card.problem_statement

                            Nothing ->
                                ""
                        )
                    ]
                ]
            , a [ class "lerge-start-button", href "#" ]
                [ i [ class "fas fa-laptop-code" ] []
                , text "答えを確認"
                ]
            ]
        ]
