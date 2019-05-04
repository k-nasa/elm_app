module Page.Question exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Nav
import Data.Card exposing (Card, dummyCard)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)



-- TODO apiサーバーからcardsを取ってくる必要あり
-- ダミーで仮置き


init : Nav.Key -> Model
init key =
    { question_count = 4
    , solved_count = 0
    , does_show_answer = False
    , key = key
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
    , key : Nav.Key
    }


type Msg
    = NoOp
    | ShowAnswer
    | SendFeed Feed


type Feed
    = Unsolve
    | Difficult
    | Solve
    | Easy


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ShowAnswer ->
            ( { model | does_show_answer = True }, Cmd.none )

        -- TODO feed をapiに投げる
        SendFeed feed ->
            case List.isEmpty (List.drop 1 model.remaining_cards) of
                False ->
                    ( { model
                        | does_show_answer = False
                        , solved_count = model.solved_count + 1
                        , remaining_cards = List.drop 1 model.remaining_cards
                      }
                    , Cmd.none
                    )

                True ->
                    redirectBack model


redirectBack : Model -> ( Model, Cmd Msg )
redirectBack model =
    ( model, Nav.back model.key 1 )


view : Model -> Html Msg
view model =
    div []
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
                            (if model.does_show_answer then
                                case List.head model.remaining_cards of
                                    Just card ->
                                        card.answer_text

                                    Nothing ->
                                        ""

                             else
                                case List.head model.remaining_cards of
                                    Just card ->
                                        card.problem_statement

                                    Nothing ->
                                        ""
                            )
                        ]
                    ]
                ]
            , if model.does_show_answer then
                div [ class "feed-buttons" ]
                    [ button [ class "btn btn-danger", onClick (SendFeed Unsolve) ] [ text "解けなかった" ]
                    , button [ class "btn btn-warning", onClick (SendFeed Difficult) ] [ text "難しい" ]
                    , button [ class "btn btn-success", onClick (SendFeed Solve) ] [ text "解けた" ]
                    , button [ class "btn btn-primary", onClick (SendFeed Easy) ] [ text "簡単" ]
                    ]

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
