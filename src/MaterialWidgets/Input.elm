module MaterialWidgets.Input
  ( input
  , textInput
  , passwordInput
  ) where

import Widgets exposing (..)
import Html exposing (Html, Attribute)
import Html.Attributes exposing (placeholder, required, type')
import Dict exposing (Dict, fromList, singleton)

textInput : String -> Bool -> Widget
textInput placeholderTxt isRequired =
  input placeholderTxt "text" isRequired

passwordInput : String -> Bool -> Widget
passwordInput placeholderTxt isRequired =
  input placeholderTxt "password" isRequired

input : String -> String -> Bool -> Widget
input placeholderTxt inputType isRequired =
  let
    baseStyle =
      fromList
        [ ("margin", "40px 25px")
        , ("display", "block")
        , ("border", "none")
        , ("padding", "10px 0")
        , ("border-bottom", "solid 1px #1abc9c")
        , ("-webkit-transition", "all 0.3s cubic-bezier(0.64, 0.09, 0.08, 1)")
        , ("transition", "all 0.3s cubic-bezier(0.64, 0.09, 0.08, 1)")
        , ("background", "-webkit-linear-gradient(top, rgba(255, 255, 255, 0) 96%, #1abc9c 4%)")
        , ("background", "linear-gradient(to bottom, rgba(255, 255, 255, 0) 96%, #1abc9c 4%)")
        , ("background-position", "-100% 0")
        , ("background-size", "100% 100%")
        , ("background-repeat", "no-repeat")
        , ("color", "#0e6252")
        ]
    focusStyle =
      fromList
        [ ("box-shadow", "none")
        , ("outline", "none")
        , ("background-position", "0 0")
        ]
    placeholderStyle =
      fromList
        [ ("-webkit-transition", "all 0.3s ease-in-out")
        , ("transition", "all 0.3s ease-in-out")
        ]
    placeholderFocusStyle =
      fromList
        [ ("color", "#1abc9c")
        , ("font-size", "11px")
        , ("-webkit-transform", "translateY(-20px)")
        , ("transform", "translateY(-20px)")
        , ("visibility", "visible !important")
        , ("display", "block !important")
        ]
    styles = fromList
      [ ("", baseStyle)
      , (":focus", focusStyle)
      , (":valid", focusStyle)
      , ("::-webkit-input-placeholder", placeholderStyle)
      , (":focus::-webkit-input-placeholder", placeholderFocusStyle)
      , (":valid::-webkit-input-placeholder", placeholderFocusStyle)]
    attrs = [required isRequired, placeholder placeholderTxt, type' inputType]
  in
    Widget styles attrs [] render


render : Styles -> (List Attribute) -> (List Widget) -> (Html, (Dict Int Styles))
render styles attrs children =
  let
    (attrsWithStyle, childrenHtml, mergedStyles) = renderHelper styles attrs children
  in
    (Html.input attrsWithStyle childrenHtml, mergedStyles)
