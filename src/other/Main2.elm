module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)
import Browser
import Html exposing (Html, Attribute, div, span, text)
import Html.Attributes exposing (..)
import Browser
import Browser.Events as Events
import Html.Events exposing (onInput)
import Json.Decode as Decode

import String

main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \() -> init
        , subscriptions = subscriptions
        , update = update
        }

type alias Model =
    { world : String,
      point: Int
    }

init : ( Model, Cmd Msg )
init =
    ({ world = "Hello World\nNewline?\nExcellent",
          point = 7},
          Cmd.none
          )

type Msg
    = KeyDowns String
    | ClearPressed

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
      KeyDowns code ->
        ( {model | world = (model.world ++ code)}, Cmd.none )
      ClearPressed ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Events.onKeyDown (Decode.map KeyDowns keyDecoder)
        , Events.onKeyUp (Decode.succeed ClearPressed)
        ]


keyDecoder : Decode.Decoder String
keyDecoder =
    Decode.field "key" Decode.string


view : Model -> Html Msg
view model =
    div [ style "white-space" "pre",
          style "font-family" "monospace"]
        [ text (String.slice 0 model.point model.world),
          span [ style "background-color" "fuchsia" ]
               [ text (String.slice model.point (model.point + 1) model.world)],
          text (String.dropLeft (model.point + 1) model.world)]