module Components.Loading exposing (loadingView)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


loadingView : Html msg
loadingView =
    div [ class "loading-view" ]
        [ div [ class "spinner-grow text-info" ]
            [ span [ class "sr-only" ] [ text "Loading" ]
            ]
        , p [ class "text-info" ] [ text "Now loading" ]
        , div [ class "spinner-grow text-info" ]
            [ span [ class "sr-only" ] [ text "Loading" ]
            ]
        ]
