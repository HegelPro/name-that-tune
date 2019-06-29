module Letter exposing
  (Letter, makeListLetter, listLetterToString
  , filterHidedLetters, positionIndexToLetterIndex
  , showLetter
  )

import Array


-- MAIN


type alias Letter =
  { value : Char
  , isHide : Bool
  , index : Int
  }



-- UTILS


makeListLetter : String -> List Letter
makeListLetter string =
  string
    |> String.toList
    |> List.indexedMap (\index value ->
        { value = value
        , isHide = False
        , index = index
        }
      )

listLetterToString : List Letter -> String
listLetterToString result =
  result
    |> List.map (.value >> String.fromChar)
    |> List.foldr (++) ""

filterHidedLetters : List Letter -> List Letter
filterHidedLetters letters =
  letters |> List.filter (\{ isHide } -> not isHide)

positionIndexToLetterIndex : Int -> List Letter -> Maybe Int
positionIndexToLetterIndex positionIndex letters =
  letters
    |> Array.fromList
    |> Array.get positionIndex
    |> \maybeLetter ->
      case maybeLetter of
          Just letter -> Just letter.index
          Nothing -> Nothing
              

showLetter : Int -> List Letter -> List Letter
showLetter positionIndex letters =
  let
    unHidedLetters = letters |> filterHidedLetters
  in
     letters
      |> List.map (\letter ->
        case positionIndexToLetterIndex positionIndex unHidedLetters of
          Just letterIndex ->
            case letterIndex == letter.index of
              True -> { letter | isHide = True }
              False -> letter
          Nothing -> letter
        )