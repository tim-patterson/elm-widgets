module MaterialWidgets.Input
  ( input
  , textInput
  , passwordInput
  ) where

import Widgets exposing (..)
import Html exposing (Html, Attribute)
import Html.Attributes exposing (placeholder, required, type')
import Dict exposing (Dict, fromList, singleton)

-- Ideas from here http://www.cssscript.com/pure-css-material-design-floating-input-placeholder/

textInput : String -> Bool -> Widget
textInput placeholderTxt isRequired =
  input placeholderTxt "text" isRequired

passwordInput : String -> Bool -> Widget
passwordInput placeholderTxt isRequired =
  input placeholderTxt "password" isRequired

input : String -> String -> Bool -> Widget
input placeholderTxt inputType isRequired =
  let
    attrs = [required isRequired, placeholder placeholderTxt, type' inputType]
  in
    Widget styles attrs [] render


render : Widget -> (Html, (Dict Int Styles))
render (Widget styles attrs children renderF) =
  let
    (attrsWithStyle, childrenHtml, mergedStyles) = renderHelper styles [] children
  in
    (Html.div attrsWithStyle [Html.input attrs childrenHtml], mergedStyles)


-- Styles
styles : Styles
styles =
  fromList
    [ ("", wrapperStyle)
    , (" input", baseStyle)
    , (" input:focus", focusStyle)
    , (" input:valid", focusStyle)
    , (" input::-webkit-input-placeholder", placeholderStyle)
    , (" input:focus::-webkit-input-placeholder", placeholderFocusStyle)
    , (" input:valid::-webkit-input-placeholder", placeholderFocusStyle)
    ]


wrapperStyle : Style
wrapperStyle =
  fromList
    [ ("margin", "40px 25px")
    , ("padding", "10px 0")
    ]


baseStyle : Style
baseStyle =
  fromList
    [ ("margin", "0")
    , ("display", "block")
    , ("border", "none")
    , ("padding", "0")
    , ("border-bottom", "solid 2px")
    , ("border-bottom-color", "@primary-color")
    , ("-webkit-transition", "all 0.3s cubic-bezier(0.64, 0.09, 0.08, 1)")
    , ("transition", "all 0.3s cubic-bezier(0.64, 0.09, 0.08, 1)")
    , ("background-color", "transparent")
    , ("color", "@hint-text")
    , ("width", "100%")
    ]


focusStyle : Style
focusStyle =
  fromList
    [ ("box-shadow", "none")
    , ("outline", "none")
    , ("background-position", "0 0")
    ]


placeholderStyle : Style
placeholderStyle =
  fromList
    [ ("-webkit-transition", "all 0.3s ease-in-out")
    , ("transition", "all 0.3s ease-in-out")
    ]


placeholderFocusStyle : Style
placeholderFocusStyle =
  fromList
    [ ("color", "@primary-color")
    , ("font-size", "11px")
    , ("-webkit-transform", "translateY(-20px)")
    , ("transform", "translateY(-20px)")
    , ("visibility", "visible !important")
    , ("display", "block !important")
    ]
