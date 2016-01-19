import Debug
import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Mouse
import Window


main : Signal Element
main =
  Signal.map2 scene Mouse.position Window.dimensions


scene : (Int,Int) -> (Int,Int) -> Element
scene (x,y) (w,h) =
  let
    (dx,dy) =
      (toFloat x - toFloat w / 2, toFloat h / 2 - toFloat y)
    d = Debug.watch "DX" dx

  in
    collage w h
      [ ngon 3 100
          |> filled blue
          |> rotate (atan2 dy dx)
      , ngon 6 30
          |> filled orange
          |> move (dx, dy)
      ]
