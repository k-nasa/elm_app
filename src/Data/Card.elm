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


cardCountTuple : Cards -> ( Int, Int )
cardCountTuple cards =
    let
        unsolveCount =
            List.length (List.filter isUnsolve cards)
    in
    ( unsolveCount, List.length cards - unsolveCount )


isUnsolve : Card -> Bool
isUnsolve card =
    card.solve_count == 0


dummyCard : Card
dummyCard =
    { id = 1
    , user_id = ""
    , problem_statement = "問題文。長いお~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    , answer_text = "回答文だお。長くするおーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー"
    , memo = "メモ"
    , question_time = "分からん"
    , solve_count = 9
    }
