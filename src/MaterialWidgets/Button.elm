module MaterialWidgets.Button (button) where

import Widgets exposing (..)
import Html exposing (Html, Attribute)
import Html.Attributes exposing (attribute)
import Dict exposing (Dict, fromList, singleton)
-- Button ideas from here : http://codepen.io/sebj54/pen/oxluI

button : String -> Widget
button label =
  Widget styles [attribute "onclick" addRemoveRippleJs] [centeredText label] render


render : Widget -> (Html, (Dict Int Styles))
render (Widget styles attrs children renderF) =
  let
    (attrsWithStyle, childrenHtml, mergedStyles) = renderHelper styles attrs children
  in
    (Html.button attrsWithStyle childrenHtml, mergedStyles)

-- styles

styles : Styles
styles =
  fromList
    [ ("", baseStyle)
    , (":hover", focusStyle)
    , (":focus", focusStyle)
    , (":before", rippleBaseStyle)
    , (".ripple:before", rippleExpandedStyle)
    ]


baseStyle : Style
baseStyle =
  fromList
    [ ("display", "inline-block")
    , ("position", "relative")
    , ("margin", "15px")
    , ("padding", "10px")
    , ("overflow", "hidden")
    , ("border-width", "0")
    , ("outline", "none")
    , ("border-radius", "2px")
    , ("box-shadow", "0 1px 4px rgba(0, 0, 0, .6)")
    , ("background-color", "@primary-color")
    , ("color", "@text-on-primary")
    , ("transition", "background-color .3s")
    , ("cursor", "pointer")
    ]


focusStyle : Style
focusStyle =
  singleton "background-color" "@primary-hover-color"

rippleBaseStyle : Style
rippleBaseStyle =
  fromList
    [ ("content", "\"\"")
    , ("position", "absolute")
    , ("top", "50%")
    , ("left", "50%")
    , ("display", "block")
    , ("width", "0")
    , ("padding-top", "0")
    , ("border-radius", "100%")
    , ("background-color", "rgba(236, 240, 241, .4)")
    , ("-webkit-transform", "translate(-50%, -50%)")
    , ("-moz-transform", "translate(-50%, -50%)")
    , ("-ms-transform", "translate(-50%, -50%)")
    , ("-o-transform", "translate(-50%, -50%)")
    , ("transform", "translate(-50%, -50%)")
    ]


rippleExpandedStyle : Style
rippleExpandedStyle =
  fromList
    [ ("width", "150%")
    , ("padding-top", "150%")
    , ("opacity", "0")
    , ("transition", "width .2s ease-out, padding-top .2s ease-out, opacity 2s")
    ]


addRemoveRippleJs : String
addRemoveRippleJs =
  "var cl = this.classList;
  clearTimeout(this.r);
  cl.remove('ripple');
  setTimeout(function(){ cl.add('ripple'); }, 0);
  this.r = setTimeout(function(){ cl.remove('ripple'); }, 2000);"
