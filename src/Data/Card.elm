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


cardDecoder : Decoder Card
cardDecoder =
    D.map7 Card
        (field "id" int)
        (field "user_id" string)
        (field "solve_count" int)
        (field "problem_statement" string)
        (field "answer_text" string)
        (field "memo" string)
        (field "question_time" string)


cardsDecoder : Decoder Cards
cardsDecoder =
    list cardDecoder
