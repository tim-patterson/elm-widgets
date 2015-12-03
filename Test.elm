import Widgets exposing (..)
import MaterialWidgets.Material as Material
import MaterialWidgets.Button as Button
import MaterialWidgets.Input as Input
import MaterialWidgets.Radio as Radio
import MaterialWidgets.Table as Table
import Html exposing (div)
import List
import Themes.HueOnWhite as Theme

import StartApp.Simple as StartApp

-- TODO
-- Add dark Theme
-- Add option for text sizes(smallest small medium large largest)
-- These could just be strings consts that the theme engine would replace
-- Create withTooltip method
-- Create div element
-- Create flexbox element + helpers
-- Option to pass styles back to the "body" div

main =
  StartApp.start { model = init, view = view, update = update }

type ThemeColor = Green | Blue

init : ThemeColor
init = Green

type Action = ChooseTheme ThemeColor

update : Action -> ThemeColor -> ThemeColor
update (ChooseTheme newColor) model =
  newColor

view : Signal.Address Action ->ThemeColor -> Html.Html
view address themeColor =
  let
    theme = case themeColor of
      Green ->
        Theme.greenTheme
      Blue ->
        Theme.blueTheme

    radio1 = Radio.radio "foo" "Blue Theme" (themeColor == Blue)
      |> withOnClick address (ChooseTheme Blue)
    radio2 = Radio.radio "foo" "Green Theme" (themeColor == Green)
      |> withOnClick address (ChooseTheme Green)

    table = createTable
    ok = Button.button "Ok" |> withWidth "80px"
    cancel = Button.button "Cancel" |> withWidth "80px"

    label = centeredText "Hello World!"
    inputField = Input.textInput "A Text field" True
    passwordField = Input.passwordInput "A Password field" True

    m = Material.material Material.Deep [label, inputField, passwordField, radio1, radio2, table, ok, cancel]
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
      --[{name="circle", sides=1}, {name="square", sides=4}, {name="hexagon", sides=6}]
      (List.map (\l -> {name=("foo" ++ (toString l)), sides=l}) [1..100] )
      rowRenderer
