module View exposing (view)

import Browser
import Html exposing (..)
import Model exposing (Model, Page(..))
import Page.Login
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
                    Page.Top.view topModel
                        |> Html.map TopMsg

                _ ->
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
