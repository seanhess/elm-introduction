import Effects exposing (Effects, Never)
import Html exposing (div, button, text, Html)
import Html.Events exposing (onClick)
import StartApp as StartApp
import Signal exposing (Address)
import Task exposing (Task)

type alias Model = Int


init : (Model, Effects Action)
init = (0, Effects.none)

view : Address Action -> Model -> Html
view address model =
  div []
    [ button [ onClick address Decrement ] [ text "-" ]
    , div [] [ text (toString model) ]
    , button [ onClick address Increment ] [ text "+" ]
    ]


type Action = Increment | Decrement


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Increment -> (model + 1, Effects.none)
    Decrement -> (model - 1, Effects.none)

-----------------------------------------------------------

app =
  StartApp.start
    { init = init
    , update = update
    , view = view
    , inputs = []
    }

main =
  app.html

port tasks : Signal (Task Never ())
port tasks =
  app.tasks

