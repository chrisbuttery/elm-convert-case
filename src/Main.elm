module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as Json exposing ((:=))
import Json.Encode as JsonEncode exposing (..)
import Task
import Array exposing (..)
import String
import Regex


type alias Model =
  { text : String
  , conversion : String
  , count : Int
  }


model: Model
model =
  { text = ""
  , conversion = ""
  , count = 0
  }


titlize : String -> String
titlize str =
  str
   |> Regex.replace (Regex.AtMost 1) (Regex.regex "(\\w)") (\{match} -> String.toUpper match)
   |> Regex.replace Regex.All (Regex.regex "\\s(\\w)") (\{match} -> String.toUpper match)


sentencize : String -> String
sentencize str =
  str
   |> String.toLower
   |> Regex.replace (Regex.AtMost 1) (Regex.regex "(\\w)") (\{match} -> String.toUpper match)


camelize : String -> String
camelize str =
  str
    |> Regex.replace Regex.All (Regex.regex "\\s(\\w)") (\{match} -> String.toUpper (String.trimLeft match))


dasherize : String -> String
dasherize str =
  str
    |> Regex.replace Regex.All (Regex.regex "\\s") (\_ -> "-")
    |> String.toLower


snakerize : String -> String
snakerize str =
  str
    |> Regex.replace Regex.All (Regex.regex "\\s") (\_ -> "_")
    |> String.toLower


type Msg
  = InputSnakeCase String
  | InputHyphenCase String
  | InputCamelCase String
  | InputTitleCase String
  | InputSentenceCase String
  | HyphenCase
  | SnakeCase
  | CamelCase
  | TitleCase
  | SentenceCase


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    InputSnakeCase text ->
      ({ model | text = text, conversion = (snakerize text) }, Cmd.none)

    InputHyphenCase text ->
      ({ model | text = text, conversion = (dasherize text) }, Cmd.none)

    InputCamelCase text ->
      ({ model | text = text, conversion = (camelize text) }, Cmd.none)

    InputTitleCase text ->
      ({ model | text = text, conversion = (titlize text) }, Cmd.none)

    InputSentenceCase text ->
      ({ model | text = text, conversion = (sentencize text) }, Cmd.none)

    CamelCase ->
      ({ model
        | conversion = (camelize model.text), count = 2 }, Cmd.none)

    HyphenCase ->
      ({ model
        | conversion = (dasherize model.text), count = 1 }, Cmd.none)

    SnakeCase ->
      ({ model
        | conversion = (snakerize model.text), count = 0 }, Cmd.none)

    TitleCase ->
      ({ model
        | conversion = (titlize model.text), count = 3 }, Cmd.none)

    SentenceCase ->
      ({ model
        | conversion = (sentencize model.text), count = 4 }, Cmd.none)


stringCases : List (String, Msg)
stringCases = [
  ("Snake", SnakeCase)
  , ("Hyphen", HyphenCase)
  , ("Camel", CamelCase)
  , ("Title", TitleCase)
  , ("Sentence", SentenceCase)
  ]


inputStringCases : List (String -> Msg)
inputStringCases = [
  InputSnakeCase
  , InputHyphenCase
  , InputCamelCase
  , InputTitleCase
  , InputSentenceCase
  ]


renderButton : Int -> Int -> (String, Msg) -> Html Msg
renderButton i count (str, msg) =
  button [ classList[("button", True), ("active", i == count)], onClick msg ] [ text str ]


renderTextarea : Int -> Int -> String -> (String -> a) -> Html a
renderTextarea i count text msg =
  textarea [ classList[("input", True), ("visible", i == count)], value text, placeholder "Dare to covert a string...", onInput msg ] []


view : Model -> Html Msg
view model =
  div [ class "app"] [
    div [ class "header" ] [
      h1 [ class "title" ] [text "Elm Convert Case"]
    ]
    , div [ class "body" ] [
        div [ class "row"] (List.indexedMap (\i val -> renderTextarea i model.count model.text val) inputStringCases)
        , div [ classList [("row", True), ("hidden", model.conversion == "")]] [
          div [ class "result" ] [
            text model.conversion
            , span [
              class "trigger"
              , Html.Attributes.attribute "data-clipboard-action" "copy"
              , Html.Attributes.attribute "data-clipboard-text" model.conversion
            ] []
          ]
        ]
      ]
    , div [ class "menu" ] (List.indexedMap (\i val -> renderButton i model.count val) stringCases)
  ]


init : Maybe Model -> ( Model, Cmd Msg )
init savedModel =
  ( Maybe.withDefault model savedModel, Cmd.none )


main =
  Html.programWithFlags
    { init = init
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }
