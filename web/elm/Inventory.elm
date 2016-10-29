module Inventory exposing(..)

import Dict exposing (Dict)
import Html exposing (Html, Attribute, a, div, hr, input, span, text)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json exposing ((:=))
import Navigation
import String
import Task
import UrlParser exposing (Parser, (</>), format, int, oneOf, s, string)

import Material
import Material.Layout as Layout
import Material.List as Lists
import Material.Options as Options exposing (css, when)
import Material.Icon as Icon
import Material.Typography as Typography
import Material.Grid as Grid exposing (grid, cell, size, Device(..))

import Pages.Dashboard as Dashboard
import Pages.Catalog as Catalog



main =
  Navigation.program (Navigation.makeParser hashParser)
    { init = init
    , view = view
    , update = update
    , urlUpdate = urlUpdate
    , subscriptions = subscriptions
    }



-- URL PARSERS - check out evancz/url-parser for fancier URL parsing


toHash : Page -> String
toHash page =
  case page of
    Dashboard ->
      "#dashboard"

    Catalog ->
      "#catalog"


hashParser : Navigation.Location -> Result String Page
hashParser location =
  UrlParser.parse identity pageParser (String.dropLeft 1 location.hash)


type Page = Dashboard | Catalog


pageParser : Parser (Page -> a) a
pageParser =
  oneOf
    [ format Dashboard (s "dashboard")
    , format Catalog (s "catalog")
    ]


-- MODEL


type alias Model =
  { mdl : Material.Model
  , page : Page
  }


model : Model
model =
  { mdl = Material.model
  , page = Dashboard
  }

init : Result String Page -> (Model, Cmd Msg)
init result =
  urlUpdate result model



-- UPDATE


type Msg = Mdl (Material.Msg Msg)


{-| A relatively normal update function. The only notable thing here is that we
are commanding a new URL to be added to the browser history. This changes the
address bar and lets us use the browser&rsquo;s back button to go back to
previous pages.
-}
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Mdl msg ->
      Material.update msg model


{-| The URL is turned into a result. If the URL is valid, we just update our
model to the new count. If it is not a valid URL, we modify the URL to make
sense.
-}
urlUpdate : Result String Page -> Model -> (Model, Cmd Msg)
urlUpdate result model =
  case Debug.log "result" result of
    Err _ ->
      ( model, Navigation.modifyUrl (toHash model.page) )

    Ok page ->
      ( { model | page = page }
      , Cmd.none
      )





-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  Layout.render Mdl model.mdl
    [ Layout.fixedHeader ]
    { header = header
    , drawer = drawer
    , tabs = ([] ,[])
    , main = [ top model ]
    }

viewLink : Page -> String -> Html msg
viewLink page description =
  a [ style [ ("padding", "0 20px") ], href (toHash page) ] [ text description]

top : Model -> Html Msg
top model =
  grid []
    [ sidebar
    , viewPage model
    ]

viewPage : Model -> Grid.Cell a
viewPage model =
  case model.page of
    Dashboard ->
      Dashboard.view

    Catalog ->
      Catalog.view

drawer : List (Html Msg)
drawer =
  [ Layout.title [] [ text "Example drawer" ]
  , Layout.navigation
    []
    [  Layout.link
        [ Layout.href "https://github.com/debois/elm-mdl" ]
        [ text "github" ]
    , Layout.link
        [ Layout.href "http://package.elm-lang.org/packages/debois/elm-mdl/latest/" ]
        [ text "elm-package" ]
    ]
  ]

header : List (Html Msg)
header =
  [ Layout.row
      [ ]
      [ Layout.title [] [ text "elm-mdl" ]
      , Layout.spacer
      , Layout.navigation []
          [ Layout.link
              [ Layout.href "https://github.com/debois/elm-mdl"]
              [ span [] [text "github"] ]
          , Layout.link
              [ Layout.href "http://package.elm-lang.org/packages/debois/elm-mdl/latest/" ]
              [ text "elm-package" ]
          ]
      ]
  ]

sidebar : Grid.Cell a
sidebar =
  cell
    [ Grid.size All 3 ]
    [ Lists.ul []
      [ Lists.li []
          [ Lists.content []
              [ Lists.icon "inbox" []
              , text "Inbox"
              ]
          ]
      , Lists.li []
          [ Lists.content []
              [ Lists.icon "send" []
              , text "Sent mail"
              ]
          ]
      , Lists.li []
          [ Lists.content []
              [ Lists.icon "delete" []
              , text "Trash"
              ]
          ]
      ]
    ]


