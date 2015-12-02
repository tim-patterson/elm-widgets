module MaterialWidgets.Material
  ( Depth(Shallow, Medium, Deep)
  , material
  , withShadow
  ) where

import Widgets exposing (..)
import Html exposing (Html, Attribute, div)
import Dict exposing (Dict, fromList, singleton)

type Depth = Shallow | Medium | Deep

material : Depth -> List Widget -> Widget
material depth children =
  Widget styles [] children render |> withShadow "" depth


-- Adds a shadow to a component
withShadow : String -> Depth -> Widget -> Widget
withShadow selector depth widget =
  let
    shadow = case depth of
      Shallow ->
        ("box-shadow", "0 2px 2px 0 rgba(0, 0, 0, 0.14), 0 1px 5px 0 rgba(0, 0, 0, 0.12), 0 3px 1px -2px rgba(0, 0, 0, 0.2)")
      Medium ->
        ("box-shadow", "0 6px 10px 0 rgba(0, 0, 0, 0.14), 0 1px 18px 0 rgba(0, 0, 0, 0.12), 0 3px 5px -1px rgba(0, 0, 0, 0.4)")
      Deep ->
        ("box-shadow", "0 16px 24px 2px rgba(0, 0, 0, 0.14), 0 6px 30px 5px rgba(0, 0, 0, 0.12), 0 8px 10px -5px rgba(0, 0, 0, 0.4)")
  in
    withStyle selector [shadow] widget


render : Widget -> (Html, (Dict Int Styles))
render (Widget styles attrs children renderF) =
  let
    (attrsWithStyle, childrenHtml, mergedStyles) = renderHelper styles attrs children
  in
    (div attrsWithStyle childrenHtml, mergedStyles)


-- Styles
styles : Styles
styles =
  singleton "" style

style : Style
style =
  fromList
    [ ("background", "white")
    , ("margin", "16px")
    , ("padding", "16px")
    , ("border-radius", "2px")
    ]
