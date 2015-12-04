module MaterialWidgets.Caching (caching) where

import Widgets exposing (..)
import Html exposing (Html, Attribute)
import Dict exposing (Dict, fromList, singleton)

type Cached = Cached a (Html, (Dict Int Styles))

-- Caching will take a widget
caching : a -> Cached -> Widget -> Widget
caching label =
  Widget styles [attribute "onclick" addRemoveRippleJs] [centeredText label] render


render : Widget -> (Html, (Dict Int Styles))
render (Widget styles attrs children renderF) =
  let
    (attrsWithStyle, childrenHtml, mergedStyles) = renderHelper styles attrs children
  in
    (Html.button attrsWithStyle childrenHtml, mergedStyles)
