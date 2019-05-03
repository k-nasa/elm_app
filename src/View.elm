module View exposing (view, viewSideBar)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (Model, Page(..))
import Page.AddCard
import Page.Login
import Page.Question
import Page.Top
import Update exposing (Msg(..))


view : Model -> Browser.Document Msg
view model =
    { title = "ankipan"
    , body =
        [ viewLoading model
            (case model.page of
                LoginPage loginModel ->
                    Page.Login.view loginModel
                        |> Html.map LoginMsg

                TopPage topModel ->
                    viewMain "top-page"
                        (Page.Top.view topModel
                            |> Html.map TopMsg
                        )

                AddCardPage pageModel ->
                    customNavBar "add-card-page"
                        "invisible-sp"
                        (Page.AddCard.view pageModel
                            |> Html.map AddCardMsg
                        )

                QuestionPage pageModel ->
                    customNavBar "question-page"
                        "invisible-sp"
                        (Page.Question.view pageModel
                            |> Html.map QuestionMsg
                        )

                NotFound ->
                    text "notfound"

                AboutPage ->
                    text "unimplement"
            )
        ]
    }


viewLoading : Model -> Html Msg -> Html Msg
viewLoading model content =
    if model.loading then
        text "loading..."

    else
        content


viewMain : String -> Html Msg -> Html Msg
viewMain id_ viewContainer =
    div [ class "main-container" ]
        [ viewSideBar ""
        , main_ [ id id_ ] [ viewContainer ]
        ]


customNavBar : String -> String -> Html Msg -> Html Msg
customNavBar id_ class_ viewContainer =
    div [ class "main-container" ]
        [ viewSideBar class_
        , main_ [ id id_ ] [ viewContainer ]
        ]


viewSideBar : String -> Html Msg
viewSideBar class_ =
    div [ id "navigation", class class_ ]
        [ div [ class "navigation-menue" ]
            [ input [ id "nav-checkbox", class "nav-unshown", type_ "checkbox" ] []
            , label [ id "nav-open-btn", for "nav-checkbox" ] [ span [] [] ]
            , label [ id "nav-close", for "nav-checkbox", class "nav-unshown" ] []
            , div [ id "nav-content" ]
                [ ul []
                    [ li [ class "unborder" ]
                        [ a [ href "/" ]
                            [ img [ src "%PUBLIC_URL%/assets/images/icon.jpeg", width 100, height 100 ] []
                            ]
                        ]
                    , li []
                        [ a [ href "#" ]
                            [ s []
                                [ i [ class "fas fa-edit" ] []
                                , text "カードを編集"
                                ]
                            ]
                        ]
                    , li []
                        [ a [ href "#" ]
                            [ s []
                                [ i [ class "fas fa-clipboard" ] []
                                , text "学習記録"
                                ]
                            ]
                        ]
                    , li []
                        [ a [ href "#" ]
                            [ s []
                                [ i [ class "fas fa-cog" ] []
                                , text "設定"
                                ]
                            ]
                        ]
                    , li []
                        [ a [ href "#", onClick ClearLocalStorageUid ]
                            [ i [ class "fas fa-sign-out-alt" ] []
                            , text "ログアウト"
                            ]
                        ]
                    , li [ class "unborder" ]
                        [ a [ href "https://twitter.com/nasa_desu" ]
                            [ i [ class "fas fa-phone" ] []
                            , text "要望"
                            ]
                        ]
                    ]
                , a [ href "https://twitter.com/intent/tweet?text=%E3%82%A2%E3%83%B3%E3%82%AD%E3%83%91%E3%83%B3%E3%81%A0%E3%81%8A", target "_bulk" ] [ text "ツイート" ]
                ]
            ]
        ]
