module Inventory exposing(..)

import Html.App as App
import Html exposing (..)
import Html.Attributes exposing (href, class, style)

import Material
import Material.Layout as Layout
import Material.Button as Button
import Material.Options exposing (css)


-- MODEL


type alias Model =
  { mdl : Material.Model
  , count : Int
  , selectedTab : Int
      -- Boilerplate: model store for any and all Mdl components you use.
  }


model : Model
model =
  { mdl = Material.model
  , count = 0
  , selectedTab = 0
  }


-- ACTION, UPDATE


type Msg
  = Increase
  | Reset
  | Mdl (Material.Msg Msg)
      -- Boilerplate: Msg clause for internal Mdl messages.


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Increase ->
      ( { model | count = model.count + 1 }
      , Cmd.none
      )

    Reset ->
      ( { model | count = 0 }
      , Cmd.none
      )

    -- Boilerplate: Mdl action handler.
    Mdl msg' ->
      Material.update msg' model


-- VIEW


type alias Mdl =
  Material.Model

header : Model -> List (Html Msg)
header model =
  [ Layout.row
    []
    [ Layout.title [] [ text "Hello Header" ] ]
  ]

drawer : List (Html Msg)
drawer =
  [ Layout.title [] [ text "Hello Drawer" ]
  , Layout.navigation
    []
    [ Layout.link
      [ Layout.href "http://google.com" ]
      [ text "Hello Link" ]
    ]
  ]

tabs : List (String, String)
tabs =
  [ ( "Tab1", "tab1" ) ]

view : Model -> Html Msg
view model =
  Layout.render Mdl model.mdl
    [ Layout.selectedTab model.selectedTab ]
    { header = header model
    , drawer = drawer
    , tabs = tabs
    , main = [  ]
    }

main : Program Never
main =
  App.program
    { init = ( model, Layout.sub0 Mdl)
    , view = view
    , subscriptions = Material.subscriptions Mdl
    , update = update
    }
