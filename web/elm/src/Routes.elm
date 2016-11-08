module Routes exposing(..)

import UrlParser exposing (Parser, parse, (</>), format, int, oneOf, s, string)
import Navigation exposing(Location)
import String
import Html.Attributes exposing(href, attribute)
import Html exposing (Html, Attribute, a)
import Html.Events exposing(onWithOptions)
import Json.Decode as Json exposing ((:=))
import Json.Decode.Extra exposing(lazy)


type Route
  = Home
  | DashboardPage
  | BucketListingPage
  | BucketDetailPage Int
  | NewBucketPage


routeParser : Parser (Route -> a) a
routeParser =
  oneOf
    [ format Home (s "")
    , format NewBucketPage (s "buckets" </> s "new")
    , format BucketDetailPage (s "buckets" </> int)
    , format BucketListingPage (s "buckets")
    , format DashboardPage (s "dashboard")
    ]


decode : Location -> Result String Route
decode location =
  parse identity routeParser (String.dropLeft 2 location.hash)


encode : Route -> String
encode route =
  case route of
    Home ->
      "/#/"

    DashboardPage ->
      "/#/dashboard"

    BucketListingPage ->
      "/#/buckets"

    BucketDetailPage i ->
      "/#/buckets/" ++ toString i

    NewBucketPage ->
      "/#/buckets/new"


navigate : Route -> Cmd msg
navigate route =
  Navigation.newUrl (encode route)


linkTo : Route -> List (Attribute msg) -> List (Html msg) -> Html msg
linkTo route attrs content =
  a ((linkAttrs route) ++ attrs) content


linkAttrs : Route -> List (Attribute msg)
linkAttrs route =
  let
      path =
          encode route
  in
      [ href path
      , attribute "data-navigate" path
      ]


catchNavigationClicks : (String -> msg) -> Attribute msg
catchNavigationClicks tagger =
  onWithOptions "click"
    { stopPropagation = True
    , preventDefault = True
    }
    (Json.map tagger (Json.at [ "target" ] pathDecoder))


pathDecoder : Json.Decoder String
pathDecoder =
  Json.oneOf
      [ Json.at [ "dataset", "navigate" ] Json.string
      , Json.at [ "parentElement" ] (lazy (\_ -> pathDecoder))
      , Json.fail "no path found for click"
      ]
