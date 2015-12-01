module MaterialWidgets.Button (button) where

import Widgets exposing (..)
import Html exposing (Html, Attribute)
import Html.Attributes exposing (attribute)
import Dict exposing (Dict, fromList, singleton)
-- Button ideas from here : http://codepen.io/sebj54/pen/oxluI

button : String -> Widget
button label =
  let
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
        , ("background-color", "#2ecc71")
        , ("color", "#ecf0f1")
        , ("transition", "background-color .3s")
        , ("cursor", "pointer") ]
    focusStyle =
      singleton "background-color" "#27ae60"
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
        , ("transform", "translate(-50%, -50%)")]
    rippleExpandedStyle =
      fromList
        [ ("width", "150%")
        , ("padding-top", "150%")
        , ("opacity", "0")
        , ("transition", "width .2s ease-out, padding-top .2s ease-out, opacity 2s")]
    styles = fromList
      [ ("", baseStyle)
      , (":hover", focusStyle)
      , (":focus", focusStyle)
      , (":before", rippleBaseStyle)
      , (".ripple:before", rippleExpandedStyle) ]
    addRemoveRippleJs = "
      var cl = this.classList;
      clearTimeout(this.r);
      cl.remove('ripple');
      setTimeout(function(){ cl.add('ripple'); }, 0);
      this.r = setTimeout(function(){ cl.remove('ripple'); }, 2000);"
  in
    Widget styles [attribute "onclick" addRemoveRippleJs] [centeredText label] render


render : Styles -> (List Attribute) -> (List Widget) -> (Html, (Dict Int Styles))
render styles attrs children =
  let
    (attrsWithStyle, childrenHtml, mergedStyles) = renderHelper styles attrs children
  in
    (Html.button attrsWithStyle childrenHtml, mergedStyles)
