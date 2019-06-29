module Main exposing (main)

import Browser exposing (Document, UrlRequest, application)
import Browser.Navigation as Nav exposing (Key)
import Url exposing (Url)
import Html exposing (Html, text, div)

import Card
import Game



-- MODEL


type alias InitState =
  { date: Int }

type Model =
  GameModel Game.Model
  {- Now unneeded
  | ClickedLinkModel
    { key : Nav.Key
    , url : Url.Url
    }
  -}

init : InitState -> Url -> Key -> ( Model, Cmd Msg )
init initState url key =
  ( case Game.init initState.date of
    (model, _, _) -> model |> GameModel
  , Cmd.none
  )



-- VIEW


view : Model -> Document Msg
view model =
  case model of
    GameModel textGame ->
      { title = "Dffok"
      , body = [
          Card.view [
            (Game.view >> Html.map GameMsg) textGame
          ]
        ]
      }
    {- Now unneeded
    _ ->
      { title = "404"
      , body = [
        div [] [
          text "Not found page!"
        ]
      ]}
    -}



-- UPDATE


type Msg =
  GameMsg Game.Msg
  | ChangedUrl Url
  | ClickedLink UrlRequest

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case (msg, model) of
    (GameMsg gameMsg, GameModel gameModel) ->
       case Game.update gameMsg gameModel of
        (game, commands, _) ->
          (GameModel game, commands |> Cmd.map GameMsg )
    {- Now unneeded
    (ClickedLink urlRequest, ClickedLinkModel clickedLinkModel) ->
      case urlRequest of
        Browser.Internal url ->
          ( model
          , Nav.pushUrl clickedLinkModel.key (Url.toString url)
          )
        Browser.External url ->
          ( model
          , Nav.load url
          )
    -}
    (_, _) ->
      ( model
      , Cmd.none
      )

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  case model of
    GameModel game -> Sub.map GameMsg (Game.subscriptions game)



-- MAIN


main : Program InitState Model Msg
main =
  application
    { init = init
    , onUrlChange = ChangedUrl
    , onUrlRequest = ClickedLink
    , update = update
    , subscriptions = subscriptions
    , view = view
    }