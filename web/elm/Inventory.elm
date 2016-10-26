module Inventory exposing(..)

import Html.App as App
import Html exposing (..)
import Html.Attributes exposing (href, class, style)

import Material
import Material.List as Lists
import Material.Layout as Layout
import Material.Button as Button
import Material.Tabs as Tabs
import Material.Icon as Icon
import Material.Typography as Typo
import Material.Options as Options exposing (Style, css, cs)
import Material.Grid exposing (grid, cell, size, Device(..))


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

iconLink : String -> String -> Html Msg
iconLink name icon =
  Layout.link
    [ Layout.href <| "#" ++ name
    , css "display" "block"
    , css "width" "100%"
    ]
    [ Lists.content [ Typo.capitalize ]
        [ Lists.icon icon []
        , text name
        ]
    ]



top : Html Msg
top =
  grid []
    [ cell [ size All 3 ] [ sidebar ]
    , cell [ size All 9 ] [ text "Content" ]
    ]

sidebar : Html Msg
sidebar =
  Lists.ul []
    [ Lists.li []
        [ iconLink "dashboard" "dashboard" ]
    , Lists.li []
        [ iconLink "inventory" "local_shipping" ]
    ]


header : Model -> List (Html Msg)
header model =
  [ Layout.row
    [ css "transition" "height 333ms ease-in-out 0s" ]
    [ Options.div
      [ css "margin-right" "10px"
      , css "font-size" "30px"
      ]
      [ Icon.i "local_shipping" ]
    , Layout.title [] [ text "Inventory IO" ]
    , Layout.spacer
    , Layout.navigation []
        [ Layout.link
            [ Layout.href "https://github.com" ]
            [ span [] [ text "link 1" ] ]
        , Layout.link
            [ Layout.href "https://github.com" ]
            [ span [] [ text "link 2" ] ]
        ]
    ]
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

tabs : (List (Html Msg), List (Style Msg))
tabs =
  (
    [ Options.div [] [ Icon.i "info_outline", text "About tabs" ]
    , Options.span [] [ text "Tab 2" ]
    ]
    ,
    []
  )

view : Model -> Html Msg
view model =
  Layout.render Mdl model.mdl
    [ Layout.selectedTab model.selectedTab
    , Layout.fixedHeader
    ]
    { header = header model
    , drawer = drawer
    , tabs = ([],[])
    , main = [ top ]
    }

main : Program Never
main =
  App.program
    { init =
      ( { model | mdl = Layout.setTabsWidth 1384 model.mdl }
        , Layout.sub0 Mdl
      )
    , view = view
    , subscriptions = Material.subscriptions Mdl
    , update = update
    }
