module Pages.Catalog exposing (..)

import Html.App as App
import Html exposing (..)
import Html.Attributes exposing (href, class, style)

import Material
import Material.Grid as Grid exposing (grid, cell, size, Device(..))

type alias Model = { mdl : Material.Model }

-- MODEL

model : Model
model = { mdl = Material.model }

-- ACTION, UPDATE

type Msg
 = Mdl (Material.Msg Msg)
 | Click

-- VIEW

view : Grid.Cell a
view =
  cell [ size All 9 ] [ text "Catalog" ]

