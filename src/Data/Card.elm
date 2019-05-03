module Data.Card exposing (Card, cardCountTuple, cardDecoder, cardsDecoder, dummyCard)

import Json.Decode as D exposing (..)


type alias Card =
    { id : Int
    , user_id : String
    , solve_count : Int
    , problem_statement : String
    , answer_text : String
    , memo : String
    , question_time : String
    }


type alias Cards =
    List Card
