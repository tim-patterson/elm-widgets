module Widgets
  ( Widget(..)
  , Styles
  , Style
  , render
  , renderHelper
  , withStyle
  , withWidth
  , withMaxWidth
  , withHeight
  , withNoSelect
  , withOnClick
  , centerHorizontally
  , text
  , centeredText
  , fromHtml
  ) where

import Dict exposing (Dict)
import Html exposing (Html, Attribute, node, div, span)
import Html.Attributes as A
import Html.Events exposing (onClick)
import Signal exposing (Address)
import Maybe
import String
import Char
import Bitwise

-- Types

-- Widget should be able to be used just like Html.Html except that it
-- Can handle css by having its "render" function build up
-- a tree for html and the set of style sheets needed to render that tree.
-- By not baking in the styles, attributes, children until "render" time
-- allows us to pass it througth transforms for adding/removing styles,
-- attributes, children etc
type Widget =
  Widget
    Styles
    (List Attribute)
    (List Widget)
    (Widget -> (Html, (Dict Int Styles)))

-- Style is a Dict of css property to css value
type alias Style = Dict String String

-- Styles is a Dict of css selector to Style
-- When rendered a generated classname will be prepended to the
-- selector, the same generated classname will be added to the owning Widget
type alias Styles = Dict String Style

type alias Theme = Dict String String


-- Function to render the final Widget tree into html.
-- The outer most Widget will be wrapped in a div containing a style Element
-- will the styles needed for the whole tree
render : Widget -> Dict String String -> Html
render (Widget styles attrs children renderF as widget) theme =
  let
    (computedHtml, computedStyles) = renderF widget
    css = renderCssStyleSheet <| applyTheme theme computedStyles
    bgColor = Dict.get "@page-background" theme |> Maybe.withDefault "#fff"
    fgColor = Dict.get "@primary-text" theme |> Maybe.withDefault "#000"
  in
    div [A.style
      [ ("padding","1px 0")
      , ("margin","-2px 0")
      , ("background-color", bgColor)
      , ("color", fgColor)
      , ("height", "100vh")
      , ("overflow", "auto")
      ]] [css, computedHtml]


applyTheme : Theme -> Dict Int Styles -> Dict Int Styles
applyTheme theme stylesByHash =
  let
    mapStyle prop val =
      Dict.get val theme |> Maybe.withDefault val
    mapStyles selector style =
      Dict.map mapStyle style
    mapStylesByHash hash styles =
      Dict.map mapStyles styles
  in
    Dict.map mapStylesByHash stylesByHash


renderCssStyleSheet : Dict Int Styles -> Html
renderCssStyleSheet stylesByHash =
  let
    body = String.concat <| mapDictToList renderCssStyles stylesByHash
  in
    node "style" [] [Html.text body]

renderCssStyles : Int -> Styles -> String
renderCssStyles styleHash styles =
  (String.concat <| mapDictToList (renderCssSelector styleHash) styles)


renderCssSelector : Int -> String -> Style -> String
renderCssSelector styleHash selector style =
  let
    body = String.concat <| mapDictToList renderCssLine style
  in
    String.concat [".style", toString styleHash, selector, " {\n", body, "}\n" ]

renderCssLine : String -> String -> String
renderCssLine k v =
  String.concat(["  ", k, ": ", v, ";\n"])

mapDictToList : (comparable -> v -> a) -> Dict comparable v -> List a
mapDictToList f dict =
  Dict.map f dict |> Dict.toList |> List.map snd

-- A helper to be used in Widgets, It renders any child widgets into html,
-- Merges the styles and returns the calcuated attrs
renderHelper : Styles -> (List Attribute) -> List Widget -> (List Attribute, List Html, Dict Int Styles)
renderHelper styles attrs children =
  let
    stylesId = stylesHashCode(styles)
    stylesDict = Dict.singleton stylesId styles

    renderChild (Widget childStyles childAttrs childChildren childRender as childWidget) =
      childRender childWidget

    childrenHtmlStyles = List.map renderChild children
    childrenHtml = List.map fst childrenHtmlStyles
    mergedStyles = List.foldl (\(_, childStyle) d -> Dict.union childStyle d) stylesDict childrenHtmlStyles
    mergedAttrs = (A.class <| "style" ++ (toString stylesId)) :: attrs
  in
    (mergedAttrs, childrenHtml, mergedStyles)


-- Functions for creating hashcodes of styles etc
-- The hashcodes are used to provide each css style with a unique
-- identifier

stylesHashCode : Styles -> Int
stylesHashCode styles =
  let
    hashF k v h =
      intWrap <| styleHashCode v + 31 * (h * 31 + (strHashCode k))
  in
    Dict.foldl hashF 0 styles



styleHashCode : Style -> Int
styleHashCode style =
  let
    hashF k v h =
      intWrap <| strHashCode v + 31 * (h * 31 + (strHashCode k))
  in
    Dict.foldl hashF 0 style


strHashCode : String -> Int
strHashCode str =
  let
    hashF c h =
      intWrap <| h * 31 + (Char.toCode c)
  in
    String.foldl hashF 0 str


intWrap : Int -> Int
intWrap i =
  Bitwise.and i (2^32 - 1)


-- Functions to transform Widget (style etc)


withStyle : String -> List (String, String) -> Widget -> Widget
withStyle selector styles (Widget wStyles wAttrs wChildren wRenderF) =
  let
    wStyleForSelector = Dict.get selector wStyles |> Maybe.withDefault Dict.empty
    mergedStyleForSelector = Dict.union (Dict.fromList styles) wStyleForSelector
    mergedWStyles = Dict.insert selector mergedStyleForSelector wStyles
  in
    Widget mergedWStyles wAttrs wChildren wRenderF


withWidth : String -> Widget -> Widget
withWidth width widget =
  withStyle "" [("width", width)] widget

withMaxWidth : String -> Widget -> Widget
withMaxWidth width widget =
  withStyle "" [("max-width", width)] widget


withHeight : String -> Widget -> Widget
withHeight height widget =
  withStyle "" [("height", height)] widget


centerHorizontally : Widget -> Widget
centerHorizontally widget =
  withStyle "" [("display", "block"), ("margin-left", "auto"), ("margin-right", "auto")] widget


withNoSelect : Widget -> Widget
withNoSelect widget =
  withStyle ""
    [
      ("-webkit-touch-callout", "none"),
      ("-webkit-user-select", "none"),
      ("-khtml-user-select", "none"),
      ("-moz-user-select", "none"),
      ("-ms-user-select", "none"),
      ("user-select", "none")
    ] widget

withOnClick : Address a -> a -> Widget -> Widget
withOnClick address action (Widget wStyles wAttrs wChildren wRenderF) =
  Widget wStyles ( (onClick address action) :: wAttrs) wChildren wRenderF

-- Simple text Widget, wraps text in a span so it can be styled etc

centeredText : String -> Widget
centeredText str =
  text str |> withStyle "" [("display", "block"), ("text-align", "center")]

text : String -> Widget
text str =
  Widget
    Dict.empty
    []
    []
    (renderTextWidget str)

-- renderHelper : Styles -> (List Attribute) -> List Widget -> (List Attribute, List Html, Dict Int Styles)
renderTextWidget : String -> Widget -> (Html, (Dict Int Styles))
renderTextWidget str (Widget styles attrs children renderF) =
  let
    (attrsWithStyle, childrenHtml, mergedStyles) = renderHelper styles attrs children
  in
    (span attrsWithStyle ((Html.text str) :: childrenHtml), mergedStyles)


-- From Html methods below here.
-- Because of the lack of tranforms exposed for Html.Html any transforms to
-- change style etc of an html component will not work

-- Converts elm-html nodes into Widgets
fromHtml : Html -> Widget
fromHtml html =
  Widget
    Dict.empty
    []
    []
    (renderHtmlWidget html)

renderHtmlWidget : Html -> Widget -> (Html, (Dict Int Styles))
renderHtmlWidget html widget =
  (html, Dict.empty)
