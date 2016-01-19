

-- http://api.giphy.com/v1/gifs/search?q=star+wars&api_key=dc6zaTOxFJmzC

import Effects exposing (Effects, Never)
import Html exposing (..)
import Html.Attributes exposing (style, type', value)
import Html.Events exposing (onClick, on, targetValue)
import Http
import Json.Decode as Json
import Task
import StartApp

-----------------------------------------------------------

app =
  StartApp.start
    { init = init "funny cats"
    , update = update
    , view = view
    , inputs = []
    }


main =
  app.html

port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks

------------------------------------------------------------


-- MODEL
type alias Model =
    { topic : String
    , gifUrl : String
    }


init : String -> (Model, Effects Action)
init topic =
  ( Model topic "assets/waiting.gif"
  , getRandomGif topic
  )


-- UPDATE

type Action
    = Request
    | NewGif (Maybe String)
    | Search String

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Request ->
      (model, getRandomGif model.topic)

    NewGif maybeUrl ->
      ( Model model.topic (Maybe.withDefault model.gifUrl maybeUrl)
      , Effects.none
      )

    Search topic ->
      ( Model topic model.gifUrl
      , Effects.none
      )


-- VIEW ---------------------------------------------------

(=>) = (,)


view : Signal.Address Action -> Model -> Html
view address model =
  div [ style [ "width" => "200px" ] ]
    [ h2 [headerStyle] [text model.topic]
    , div [imgStyle model.gifUrl] []

    , div []
        [ input
          [ type' "text"
          , on "input" targetValue (Signal.message address << Search)
          , value model.topic
          ]
          []
        ]
    , button [ onClick address Request ] [ text "Search" ]
    ]


headerStyle : Attribute
headerStyle =
  style
    [ "width" => "200px"
    , "text-align" => "center"
    ]


imgStyle : String -> Attribute
imgStyle url =
  style
    [ "display" => "inline-block"
    , "width" => "200px"
    , "height" => "200px"
    , "background-position" => "center center"
    , "background-size" => "cover"
    , "background-image" => ("url('" ++ url ++ "')")
    ]


-- EFFECTS

getRandomGif : String -> Effects Action
getRandomGif topic =
  Http.get decodeUrl (randomUrl topic)
    |> Task.toMaybe
    |> Task.map NewGif
    |> Effects.task


randomUrl : String -> String
randomUrl topic =
  Http.url "http://api.giphy.com/v1/gifs/random"
    [ "api_key" => "dc6zaTOxFJmzC"
    , "tag" => topic
    ]


decodeUrl : Json.Decoder String
decodeUrl =
  Json.at ["data", "image_url"] Json.string
