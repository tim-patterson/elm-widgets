module Themes.Light where

import Dict exposing (Dict, fromList)
import String

greenTheme : Dict String String
greenTheme =
  themeFromColor (46, 204, 113)

blueTheme : Dict String String
blueTheme =
  themeFromColor (54, 141, 202)

themeFromColor : (Int, Int, Int) -> Dict String String
themeFromColor (r, b, g) =
  let
    toCssColor (r, b, g) =
      String.concat ["rgb(", (toString r), ",", (toString b), ",", (toString g), ")"]
    primaryColor = toCssColor (r, b, g)
    hoverColor = toCssColor (r * 85 // 100, b * 85 // 100, g * 85 // 100)
  in
    fromList
      [ ("@page-background", "#e0e0e0")
      , ("@background-color", "#ffffff") -- Color used for backgrounds
      , ("@primary-text", "#111111") -- Color used for most text
      , ("@secondary-text", "#8a8a8a")  -- Color used for secondary text
      , ("@hint-text", "#999999") -- Color used for hints, placeholders etc
      , ("@divider-color", "#e0e0e0")
      , ("@background-hover-color", "#f4f4f4")
      , ("@primary-color", primaryColor) -- main color of the theme, eg green in this case
      , ("@primary-hover-color", hoverColor) -- color of buttons etc when hovered over
      , ("@text-on-primary", "#ffffff") -- color of text when placed on the primary color(eg button text)
      ]
