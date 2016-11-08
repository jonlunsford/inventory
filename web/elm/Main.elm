module Main exposing(..)

import Home
import Dashboard
import BucketListing
import BucketDetail
import Routes exposing(..)

import Html exposing(..)
import Html.Attributes exposing (..)
import Html.App as App
import Navigation

import Material
import Material.Layout as Layout
import Material.List as Lists
import Material.Options as Options exposing (css, when)
import Material.Icon as Icon
import Material.Typography as Typography
import Material.Grid as Grid exposing (grid, cell, size, Device(..))



main : Program Never
main =
  Navigation.program (Navigation.makeParser Routes.decode)
    { init = init
    , view = view
    , update = update
    , urlUpdate = urlUpdate
    , subscriptions = subscriptions
    }


type alias Model =
  { mdl : Material.Model
  , route : Routes.Route
  , homeModel : Home.Model
  , dashboardModel : Dashboard.Model
  , bucketListingModel : BucketListing.Model
  , bucketDetailModel : BucketDetail.Model
  }


type Msg
  = Mdl (Material.Msg Msg)
  | HomeMsg Home.Msg
  | BucketListingMsg BucketListing.Msg
  | BucketDetailMsg BucketDetail.Msg
  | DashboardMsg Dashboard.Msg
  | Navigate String


initialModel : Model
initialModel =
  { mdl = Material.model
  , route = Home
  , homeModel = Home.init
  , dashboardModel = Dashboard.init
  , bucketListingModel = BucketListing.init
  , bucketDetailModel = BucketDetail.init
  }


init : Result String Route -> (Model, Cmd Msg)
init result =
  urlUpdate result initialModel


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Mdl msg ->
      Material.update msg model

    HomeMsg m ->
      let
          ( subMdl, subCmd ) =
              Home.update m model.homeModel
      in
          { model | homeModel = subMdl }
              ! [ Cmd.map HomeMsg subCmd ]

    BucketListingMsg m ->
      let ( subMdl, subCmd ) =
              BucketListing.update m model.bucketListingModel
      in
          { model | bucketListingModel = subMdl }
              ! [ Cmd.map BucketListingMsg subCmd ]

    BucketDetailMsg m ->
      let
          ( subMdl, subCmd ) =
              BucketDetail.update m model.bucketDetailModel
      in
          { model | bucketDetailModel = subMdl }
              ! [ Cmd.map BucketDetailMsg subCmd ]

    DashboardMsg m ->
      let ( subMdl, subCmd ) =
              Dashboard.update m model.dashboardModel
      in
          { model | dashboardModel = subMdl }
              ! [ Cmd.map DashboardMsg subCmd ]

    Navigate url ->
      model ! [ Navigation.newUrl url ]



urlUpdate : Result String Route -> Model -> (Model, Cmd Msg)
urlUpdate result model =
  case Debug.log "result" result of
    Err _ ->
      ( model, Navigation.modifyUrl (Routes.encode model.route) )

    Ok (BucketListingPage as route) ->
        { model | route = route }
            ! [ Cmd.map BucketListingMsg BucketListing.mountCmd ]

    Ok (DashboardPage as route) ->
        { model | route = route }
            ! [ Cmd.map DashboardMsg Dashboard.mountCmd ]

    Ok ((BucketDetailPage bucketId) as route) ->
        { model | route = route }
            ! [ Cmd.map BucketDetailMsg <| BucketDetail.mountShowCmd bucketId ]

    Ok (NewBucketPage as route) ->
        { model | route = route, bucketDetailModel = BucketDetail.init } ! []

    Ok route ->
      { model | route = route } ! []


-- VIEW


view : Model -> Html Msg
view model =
  Layout.render Mdl model.mdl
    [ Layout.fixedHeader ]
    { header = header
    , drawer = drawer
    , tabs = ([],[])
    , main = [ top model ]
    }


top : Model -> Html Msg
top model =
  div
    [ Routes.catchNavigationClicks Navigate ]
    [ Routes.linkTo Routes.BucketListingPage [] [ text "Buckets" ]
    , Routes.linkTo Routes.DashboardPage [] [ text "Dashbaord" ]
    , Routes.linkTo Routes.Home [] [ text "Home" ]
    , contentView model
    ]


contentView : Model -> Html Msg
contentView model =
  case model.route of
    Home ->
      App.map HomeMsg <| Home.view model.homeModel

    DashboardPage ->
      App.map DashboardMsg <| Dashboard.view model.dashboardModel

    BucketListingPage ->
      App.map BucketListingMsg <| BucketListing.view model.bucketListingModel

    BucketDetailPage id ->
      div [] [ text "Bucket Detail" ]

    NewBucketPage ->
      div [] [ text "New Bucket" ]


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
      [ Icon.i "local_shipping"
      , Layout.title [ css "margin-left" "10px" ]
          [ text "Inventory IO" ]
      , Layout.spacer
      , Layout.navigation []
          [ Layout.link
            [ Layout.href "#" ]
            [ text "Log out" ]
          ]
      ]
  ]

styleBlockLink : List (String, String)
styleBlockLink =
  [ ("display", "block")
  , ("min-width", "100%")
  , ("text-decoration", "none")
  ]

blockLink : Route -> String -> String -> Html a
blockLink route iconName description =
  Routes.linkTo route [ style <| styleBlockLink ]
      [ Lists.content []
          [ Lists.icon iconName []
          , text description
          ]
      ]

sidebar : Grid.Cell a
sidebar =
  cell
    [ Grid.size All 3
    , css "margin" "0 8px 0 0"
    , css "height" "95vh"
    , css "background" "#fff"
    ]
    [ Lists.ul []
      [ Lists.li []
          [ blockLink Routes.DashboardPage "dashboard" "Dashboard" ]
      , Lists.li []
          [ blockLink Routes.BucketListingPage "local_shipping" "Bucket Listing" ]
      ]
    ]



subscriptions : Model -> Sub Msg
subscriptions model =
  Material.subscriptions Mdl model
