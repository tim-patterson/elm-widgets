module MaterialWidgets.Button (button) where

import Widgets exposing (..)
import MaterialWidgets.Material exposing (material, Depth(Shallow,Medium), withShadow)

button : String -> Widget
button label =
  material Medium [ text label ]
  |> withStyle ""
    [
      ("padding", "12px"),
      ("margin", "8px"),
      ("border-radius", "4px"),
      ("display", "inline-block"),
      ("cursor", "pointer")
    ]
  |> withStyle ":hover" [("color", "blue")]
  |> withShadow ":active" Shallow
  |> withNoSelect
