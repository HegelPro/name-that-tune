module Pape exposing (..)

import Html.Events exposing (onClick)
import Html exposing (..)
import Html.Attributes exposing (..)

type Msg = Click String

type alias Model =
  { value : String }

type Return
  = String

init : String -> (Model, Cmd Msg, Maybe Return)
init str = 
  ( { value = str }, Cmd.none, Nothing )

update : Msg -> Model -> (Model, Cmd Msg, Maybe Return)
update msg model =
  case msg of
    Click value ->
      ({ model | value = value }, Cmd.none, Nothing )

view : Model -> Html Msg
view { value } =
  div [ onClick (Click "fff") ]
    [ text (value ++ "fdf") ]