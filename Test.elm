import Widgets exposing (..)
import MaterialWidgets.Material as Material
import MaterialWidgets.Button as Button
import MaterialWidgets.Input as Input
import MaterialWidgets.Radio as Radio
import MaterialWidgets.Table as Table
import Html exposing (div)
import List
import Themes.Light as LTheme
import Themes.Dark as DTheme

import StartApp.Simple as StartApp

-- TODO
-- Add option for text sizes(smallest small medium large largest)
-- These could just be strings consts that the theme engine would replace
-- Create withTooltip method
-- Create div element
-- Create flexbox element + helpers

main =
  StartApp.start { model = init, view = view, update = update }

type ThemeColor = Green | Blue | Dark

init : ThemeColor
init = Blue

type Action = ChooseTheme ThemeColor

update : Action -> ThemeColor -> ThemeColor
update (ChooseTheme newColor) model =
  newColor

view : Signal.Address Action ->ThemeColor -> Html.Html
view address themeColor =
  let
    theme = case themeColor of
      Green ->
        LTheme.greenTheme
      Blue ->
        LTheme.blueTheme
      Dark ->
        DTheme.dark

    radioB = Radio.radio "themeColor" "Blue Theme" (themeColor == Blue)
      |> withOnClick address (ChooseTheme Blue)
    radioG = Radio.radio "themeColor" "Green Theme" (themeColor == Green)
      |> withOnClick address (ChooseTheme Green)
    radioD = Radio.radio "themeColor" "Dark Theme" (themeColor == Dark)
      |> withOnClick address (ChooseTheme Dark)

    table = createTable
    ok = Button.button "Ok" |> withWidth "80px"
    cancel = Button.button "Cancel" |> withWidth "80px"

    label = centeredText "Hello World!"
    inputField = Input.textInput "A Text field" True
    passwordField = Input.passwordInput "A Password field" True

    m = Material.material Material.Deep
      [label
      , inputField, passwordField
      , radioB, radioG, radioD
      , table
      , ok, cancel
      ]
      |> withWidth "600px"
      |> centerHorizontally
      |> withStyle "" [("margin-top", "30px")]
  in
    Widgets.render m theme

createTable : Widget
createTable =
  let
    rowRenderer {name, sides} =
      [ text name
      , text <| toString sides
      , Button.button "Do something" |> withStyle "" [("margin", "0")]
      ]
  in
    Table.table
      ["Name", "Sides", "Action"]
      [{name="circle", sides=1}, {name="square", sides=4}, {name="hexagon", sides=6}]
      --(List.map (\l -> {name=("foo" ++ (toString l)), sides=l}) [1..100] )
      rowRenderer
