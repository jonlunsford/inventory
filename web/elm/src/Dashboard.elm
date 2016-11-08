module Dashboard exposing (..)

import Html.App as App
import Html exposing (..)
import Html.Attributes exposing (href, class, style)

import Material
import Material.Grid as Grid exposing (grid, cell, size, Device(..))
import Material.Options as Options exposing(css)
import Material.Layout as Layout

type alias Model =
  { mdl : Material.Model
  , url : String
  }

-- MODEL

model : Model
model =
  { mdl = Material.model
  , url = "#dashboard"
  }

init : Model
init =
    model

-- ACTION, UPDATE

type Msg
 = Mdl (Material.Msg Msg)
 | Show


mountCmd : Cmd Msg
mountCmd =
  Cmd.none

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Mdl msg ->
      Material.update msg model

    Show ->
        ( model, Cmd.none )

-- VIEW

view : Model -> Html Msg
view model =
  div [] [ text "Dashboard" ]

