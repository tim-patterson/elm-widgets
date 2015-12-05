module MaterialWidgets.Table (table) where

import Widgets exposing (..)
import Html exposing (Html, Attribute, thead, tbody, tr, th, td, text)
import Html.Attributes exposing (attribute)
import Dict exposing (Dict, fromList, singleton)


table : List String -> List a -> (a -> List Widget) -> Widget
table headers data rowRenderer =
  Widget styles [] [] <| render headers data rowRenderer


render : List String -> List a -> (a -> List Widget) -> Widget -> (Html, (Dict Int Styles))
render headers data rowRenderer (Widget styles attrs children renderF) =
  let
    allCellsAsWidgets = List.map rowRenderer data
    allCellsAsHtmlAndStyles = List.map (List.map renderWidget) allCellsAsWidgets

    allCellsAsHtml = List.map (List.map fst) allCellsAsHtmlAndStyles

    (attrsWithStyle, _, tableStyles) = renderHelper styles attrs []

    mergedStyles = List.foldl (\(_, childStyle) d -> Dict.union childStyle d) tableStyles <| List.concat allCellsAsHtmlAndStyles

    htmlTable =
      Html.table attrsWithStyle
        [ thead []
          [ tr [] <| List.map (\header -> th [] [Html.text header]) headers
          ]
        , tbody [] <| List.map renderRow allCellsAsHtml
        ]
  in
    (htmlTable, mergedStyles)

renderRow : List Html -> Html
renderRow rowCells =
    tr [] <| List.map (\cell -> td [] [cell]) rowCells


renderWidget : Widget -> (Html, (Dict Int Styles))
renderWidget (Widget styles attrs children renderF as widget) =
  renderF widget


-- Styles
styles : Styles
styles = fromList
  [ ("", baseStyle)
  , (" > * > tr > *", tdStyle)
  , (" > thead > tr > th", thStyle)
  , (" > tbody > tr:hover", trHoverStyle)
  ]


baseStyle : Style
baseStyle =
  fromList
    [ ("width", "100%")
    , ("max-width", "100%")
    , ("margin-bottom", "20px")
    , ("border-collapse", "collapse")
    ]


tdStyle : Style
tdStyle =
  fromList
    [ ("padding", "10px")
    , ("border-bottom-style", "solid")
    , ("border-bottom-color", "@divider-color")
    , ("border-bottom-width", "1px")
    , ("text-align", "left")
    ]

thStyle : Style
thStyle =
  singleton "border-bottom-width" "2px"


trHoverStyle : Style
trHoverStyle =
  singleton "background-color" "@background-hover-color"
