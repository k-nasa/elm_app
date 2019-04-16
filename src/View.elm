module View exposing (view, viewSideBar)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (Model, Page(..))
import Page.AddCard
import Page.Login
import Page.Top
import Update exposing (Msg(..))


view : Model -> Browser.Document Msg
view model =
    { title = "ankipan"
    , body =
        [ main_ []
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
                        viewMain "top-page"
                            (Page.AddCard.view pageModel
                                |> Html.map AddCardMsg
                            )

                    _ ->
                        text "unimplement"
                )
            ]
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
        [ viewSideBar
        , div [ id id_ ] [ viewContainer ]
        ]


viewSideBar : Html Msg
viewSideBar =
    div [ id "sidebar" ]
        [ div [ class "sidebar-menue" ]
            [ ul []
                [ li [ class "unborder" ] [ a [ href "/" ] [ img [ src "%PUBLIC_URL%/assets/images/icon.jpeg", width 100, height 100 ] [] ] ]
                , li []
                    [ a [ href "#" ]
                        [ i [ class "fas fa-edit" ] []
                        , text "カードを編集"
                        ]
                    ]
                , li []
                    [ a [ href "#" ]
                        [ i [ class "fas fa-clipboard" ] []
                        , text "学習記録"
                        ]
                    ]
                , li []
                    [ a [ href "#" ]
                        [ i [ class "fas fa-cog" ] []
                        , text "設定"
                        ]
                    ]
                , li []
                    [ a [ href "#" ]
                        [ i [ class "fas fa-question" ] []
                        , text "ヘルプ"
                        ]
                    ]
                , li []
                    [ a [ href "#", onClick ClearLocalStorageUid ]
                        [ i [ class "fas fa-sign-out-alt" ] []
                        , text "ログアウト"
                        ]
                    ]
                , li [ class "unborder" ]
                    [ a [ href "#" ]
                        [ i [ class "fas fa-phone" ] []
                        , text "要望"
                        ]
                    ]
                ]
            , a [ href "https://twitter.com/intent/tweet?text=%E3%82%A2%E3%83%B3%E3%82%AD%E3%83%91%E3%83%B3%E3%81%A0%E3%81%8A", target "_bulk" ] [ text "ツイート" ]
            ]
        ]
