import Widgets exposing (..)
import MaterialWidgets.Material as Material
import MaterialWidgets.Button as Button
import MaterialWidgets.Input as Input
import Html exposing (div)

-- TODO
-- Animate ripple on button
-- Radio Button element for switching themes
-- Add Theme engine (css vars)
-- Add option for text sizes(smallest small medium large largest)
-- These could just be strings consts that the theme engine would replace
-- Create div element
-- Create flexbox element + helpers
-- Option to pass styles back to the "body" div





main =
  let
    ok = Button.button "Ok" |> withWidth "60px"
    cancel = Button.button "Cancel" |> withWidth "60px"

    label = centeredText "Hello World!"
    inputField = Input.textInput "A Text field" True |> withWidth "400px"
    passwordField = Input.passwordInput "A Password field" True |> withWidth "400px"
    lineBreak = fromHtml <| div [] []

    m = Material.material Material.Deep [label, inputField, passwordField, ok, cancel]
      |> withWidth "600px"
      |> centerHorizontally
      |> withStyle "" [("margin-top", "30px")]
  in
    Widgets.render m
