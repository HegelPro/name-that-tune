module Game exposing (Msg, Model, init, update, view, subscriptions)

import Html.Events exposing (onClick, onInput)
import Html exposing (Html, div, button, text, input)
import Html.Attributes exposing (class, disabled)
import Time exposing (Posix)
import Letter exposing (Letter, makeListLetter, listLetterToString, filterHidedLetters, showLetter)
import FormatString exposing (isEquelString)
import Random

type Return
  = String



-- MODEL


type alias Model =
  { guessResult : String
  , shadowValue : String
  , result : List Letter
  , time : Int
  }

init : Int -> (Model, Cmd Msg, Maybe Return)
init startValue =
  ( { guessResult = ""
    , shadowValue = ""
    , result = makeListLetter "Fff"
    , time = 0
    }
  , Cmd.none
  , Nothing
  )



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ viewScreen model
    , viewIsEquel model
    , div [] [ text ("Value = " ++ model.guessResult) ]
    , viewInput model
    , viewSubmit model
    , viewTimer model
    ]

viewIsEquel : Model -> Html Msg
viewIsEquel { result, guessResult } =
  let
    formatedResult = listLetterToString result
  in
    div []
      [ case isEquelString formatedResult guessResult of
        True -> text "True"
        False -> text "False"
      ]

viewInput : Model -> Html Msg
viewInput { guessResult } =
  input [ onInput Input ]
    [ text guessResult ]

viewSubmit : Model -> Html Msg
viewSubmit { shadowValue } =
  button [ onClick (SaveInput shadowValue) ]
    [ text "Submit" ]

viewTimer : Model -> Html Msg
viewTimer model =
  div []
    [ button [ onClick UpdateTime ]
      [ text ( String.fromInt model.time ) ]
    ]

viewScreen : Model -> Html Msg
viewScreen { result } =
  result
    |> List.map (\letter ->
      button
        [ class (String.join " " ["btn", "btn-success"])
        , case letter.isHide of
            True -> disabled True
            False -> disabled False
        ]
        [ text (String.fromChar letter.value) ]
      )
    |> \template -> div [] template


-- UPDATE


type Msg =
  Input String
  | SaveInput String
  | Tick Posix
  | UpdateTime
  | ShowLetter Int

update : Msg -> Model -> (Model, Cmd Msg, Maybe Return)
update msg model =
  case msg of
    Input value ->
      ( { model | shadowValue = value }
      , Cmd.none
      , Nothing
      )
    SaveInput value ->
      ( { model | guessResult = value }
      , Cmd.none
      , Nothing
      )
    Tick newTime ->
      let
        unHidedLetters = filterHidedLetters model.result
      in
        ( { model | time = (model.time + 1) }
        , case (\number -> modBy 4 number == 0) model.time of
            True -> Random.generate ShowLetter (Random.int 0 ((List.length unHidedLetters - 1)))
            False -> Cmd.none
        , Nothing
        )
    UpdateTime ->
      ( { model | time = 0, result = makeListLetter "Meh"}
      , Cmd.none
      , Nothing
      )
    ShowLetter index ->
      let
        unHidedLetters = filterHidedLetters model.result
      in
        ( { model | result = showLetter index model.result }
        , Cmd.none
        , Nothing
        )




-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every 1000 Tick