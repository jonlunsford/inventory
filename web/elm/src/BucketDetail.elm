module BucketDetail exposing (Model, Msg, init, view, update, mountShowCmd)

import ServerClient exposing(..)
import Routes
import Html exposing (..)
import Html.Attributes exposing (href, class, style)
import Html.Events exposing(onClick)
import Http

import Material
import Material.Grid as Grid exposing (grid, cell, size, Device(..))
import Material.Options as Options exposing(css)
import Material.Layout as Layout


type alias Model =
  { mdl: Material.Model
  , id : Maybe Int
  , companyId : Maybe Int
  , name : String
  }


type alias BucketRowId =
  Int


type Msg
  = ShowBucket Bucket
  | FetchBucketFailed Http.Error


initialModel : Model
initialModel =
  { mdl = Material.model
  , id = Nothing
  , companyId = Nothing
  , name = ""
  }


init : Model
init =
  initialModel


mountShowCmd : Int -> Cmd Msg
mountShowCmd id =
  ServerClient.getBucket id FetchBucketFailed ShowBucket


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ShowBucket bucket ->
      ( createBucketModel model bucket, Cmd.none )

    FetchBucketFailed err ->
      ( model, Cmd.none )


createBucketModel : Model -> Bucket -> Model
createBucketModel model bucket =
  { mdl = Material.model
  , id = Just bucket.id
  , companyId = Just bucket.companyId
  , name = bucket.name
  }


view : Model -> Html Msg
view bucket =
  div [] [ text bucket.name  ]

