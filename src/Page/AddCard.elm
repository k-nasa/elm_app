module Page.AddCard exposing (Model, Msg, init, update, view)

import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (class, cols, href, id, placeholder, rows, type_, value)
import Html.Events exposing (..)
import Http
import Port


init : Nav.Key -> ( Model, Cmd Msg )
init key =
    ( { questionText = ""
      , answerText = ""
      , memo = ""
      , serverError = ""
      , errors = { questionText = "", answerText = "" }
      , key = key
      }
    , Cmd.none
    )


type alias Model =
    { questionText : String
    , answerText : String
    , memo : String
    , serverError : String
    , key : Nav.Key
    , errors : Errors
    }


type alias Errors =
    { questionText : String
    , answerText : String
    }


type Msg
    = Submit
    | InputQuestion String
    | InputAnswer String
    | InputMemo String
    | GotServerResponse (Result Http.Error String)


httpErrorToString : Http.Error -> String
httpErrorToString err =
    case err of
        Http.BadUrl _ ->
            "BadUrl"

        Http.Timeout ->
            "Timeout"

        Http.NetworkError ->
            "NetworkError"

        Http.BadStatus _ ->
            "BadStatus"

        Http.BadBody s ->
            "BadBody: " ++ s


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InputQuestion s ->
            let
                errors =
                    model.errors
            in
            ( { model | questionText = s, errors = { errors | questionText = validateQuestionText s } }, Cmd.none )

        InputAnswer s ->
            let
                errors =
                    model.errors
            in
            ( { model | answerText = s, errors = { errors | answerText = validateAnswerText s } }, Cmd.none )

        InputMemo s ->
            ( { model | memo = s }, Cmd.none )

        GotServerResponse res ->
            case res of
                Ok _ ->
                    redirectBack model

                Err err ->
                    ( { model | serverError = httpErrorToString err }, Cmd.none )

        Submit ->
            let
                newErrors =
                    { questionText = validateQuestionText model.questionText
                    , answerText = validateAnswerText model.answerText
                    }
            in
            if formValidation newErrors then
                ( { model | errors = newErrors }, Cmd.none )

            else
                ( model
                , Http.post
                    { url = "http://localhost:8080/cards"
                    , body = Http.emptyBody
                    , expect = Http.expectString GotServerResponse
                    }
                )


redirectBack : Model -> ( Model, Cmd Msg )
redirectBack model =
    ( model, Nav.back model.key 1 )


formValidation : Errors -> Bool
formValidation errors =
    if errors == Errors "" "" then
        False

    else
        True


validateQuestionText : String -> String
validateQuestionText s =
    if String.isEmpty s then
        "問題文が空だよ"

    else
        ""


validateAnswerText : String -> String
validateAnswerText s =
    if String.isEmpty s then
        "回答文が空だよ"

    else
        ""


errorFormClass : String
errorFormClass =
    "is-invalid"


hasError : String -> String
hasError s =
    if String.isEmpty s then
        ""

    else
        errorFormClass


view : Model -> Html Msg
view model =
    div []
        [ navBar
        , form [ class "card-form", onSubmit Submit ]
            [ div [] [ text model.serverError ]
            , div [ class "form-header" ]
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


navBar : Html Msg
navBar =
    div [ class "question-nav-bar bg-light" ]
        [ nav [ class "navbar navbar-expand-lg navbar-light" ]
            [ a [ class "navbar-brand back-button", href "/" ]
                [ i [ class "fas fa-arrow-left" ] []
                ]
            ]
        ]
