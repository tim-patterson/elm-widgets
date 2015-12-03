module MaterialWidgets.Radio (radio) where

import Widgets exposing (..)
import Html exposing (Html, Attribute)
import Dict exposing (Dict, fromList, singleton)
import Html.Attributes as A exposing (type', name, class)


radio : String -> String -> Bool-> Widget
radio groupName label checked=
  let
    attrs = [type' "radio", name groupName, A.checked checked]
  in
    Widget styles attrs [] <| render label



render : String -> Widget -> (Html, (Dict Int Styles))
render label (Widget styles attrs children renderF) =
  let
    (attrsWithStyle, childrenHtml, mergedStyles) = renderHelper styles [] children
  in
    (Html.label attrsWithStyle
      [  Html.input attrs childrenHtml, Html.span [class "outer"]
        [ Html.span [class "inner"] []
        ]
      , Html.text label
      ], mergedStyles)


-- Radio button ideas from here: http://codepen.io/jchristianhall/pen/cvFrm

-- Styles
styles : Styles
styles =
  fromList
    [ ("", baseStyle)
    , (":hover .inner", hoverInnerStyle)
    , (" input", inputStyle)
    , (" input:checked + .outer .inner", checkedStyle)
    , (" input:checked + .outer", checkedOuterStyle)
    , (" input:focus + .outer .inner", focusStyle)
    , (" .outer", outerStyle)
    , (" .inner", innerStyle)
    ]


baseStyle : Style
baseStyle =
  fromList
    [ ("margin", "0px 25px")
    , ("padding-right", "20px")
    , ("font-size", "18px")
    , ("line-height", "49px")
    , ("cursor", "pointer")
    , ("display", "block")
    ]


hoverInnerStyle : Style
hoverInnerStyle =
  fromList
    [ ("-webkit-transform", "scale(0.5)")
    , ("-ms-transform", "scale(0.5)")
    , ("transform", "scale(0.5)")
    , ("opacity", ".5")
    ]

inputStyle : Style
inputStyle =
  fromList
    [ ("width", "1px")
    , ("height", "1px")
    , ("opacity", "0")
    ]


checkedStyle : Style
checkedStyle =
  fromList
    [ ("-webkit-transform", "scale(1)")
    , ("-ms-transform", "scale(1)")
    , ("transform", "scale(1)")
    , ("opacity", "1")
    ]


checkedOuterStyle : Style
checkedOuterStyle =
  fromList
    [ ("border", "3px solid")
    , ("border-color", "@primary-color")
    ]


focusStyle : Style
focusStyle =
  fromList
    [ ("-webkit-transform", "scale(1)")
    , ("-ms-transform", "scale(1)")
    , ("transform", "scale(1)")
    , ("opacity", "1")
    , ("background-color", "@primary-color")
    ]

outerStyle : Style
outerStyle =
  fromList
    [ ("width", "20px")
    , ("height", "20px")
    , ("display", "block")
    , ("float", "left")
    , ("margin", "10px 9px 10px 10px")
    , ("border", "3px solid")
    , ("border-color", "@hint-text")
    , ("border-radius" ,"50%")
    ]

innerStyle : Style
innerStyle =
  fromList
    [ ("-webkit-transition", "all 0.25s ease-in-out")
    , ("transition", "all 0.25s ease-in-out")
    , ("width", "16px")
    , ("height", "16px")
    , ("-webkit-transform", "scale(0)")
    , ("-ms-transform", "scale(0)")
    , ("transform", "scale(0)")
    , ("display", "block")
    , ("margin", "2px")
    , ("border-radius", "50%")
    , ("background-color", "@primary-color")
    , ("opacity", "0")
    ]
