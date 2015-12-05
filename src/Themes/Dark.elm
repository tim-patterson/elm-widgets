module Themes.Dark where

import Dict exposing (Dict, fromList)
import String

dark : Dict String String
dark =
  fromList
    [ ("@page-background", "#242424")
    , ("@background-color", "#353535") -- Color used for backgrounds
    , ("@primary-text", "#ffffff") -- Color used for most text
    , ("@secondary-text", "#b3b3b3")  -- Color used for secondary text
    , ("@hint-text", "#4d4d4d") -- Color used for hints, placeholders etc
    , ("@divider-color", "#616161")
    , ("@background-hover-color", "#3d3d3d")
    , ("@primary-color", "#679FCF") -- main color of the theme, eg green in this case
    , ("@primary-hover-color", "#3D84C2") -- color of buttons etc when hovered over
    , ("@text-on-primary", "#ffffff") -- color of text when placed on the primary color(eg button text)
    ]
