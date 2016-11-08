module BucketListing exposing (Model, Msg, init, view, update, mountCmd)

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

-- MODEL

type alias Model =
  { mdl : Material.Model
  , buckets : List Bucket
  , errors : List String
  }

type Msg
  = Mdl (Material.Msg Msg)
  | Show
  | HandleBucketsRetrieved (List Bucket)
  | FetchBucketsFailed Http.Error
  | DeleteBucket Int
  | HandleBucketDeleted
  | DeleteFailed

model : Model
model =
  { mdl = Material.model
  , buckets = []
  , errors = []
  }

init : Model
init =
    model

-- ACTION, UPDATE

mountCmd : Cmd Msg
mountCmd =
  ServerClient.getBuckets FetchBucketsFailed HandleBucketsRetrieved


update : Msg -> Model -> (Model , Cmd Msg)
update action model =
  case action of
    Mdl msg ->
      Material.update msg model

    Show ->
      ( model, mountCmd )

    HandleBucketsRetrieved buckets ->
      ( { model | buckets = buckets }
      , Cmd.none
      )

    FetchBucketsFailed err ->
      ( model, Cmd.none )

    DeleteBucket id ->
      ( model, deleteBucket id DeleteFailed HandleBucketDeleted )

    HandleBucketDeleted ->
      update Show model

    DeleteFailed ->
      ( model, Cmd.none )

-- VIEW

view : Model -> Html Msg
view model =
  div
    []
    [ h1 [] [ text "Buckets" ]
    , Routes.linkTo Routes.NewBucketPage []
        [ text "New Bucket" ]
    , ul
        []
        (List.map bucketItem model.buckets)
    ]

bucketItem : Bucket -> Html Msg
bucketItem bucket =
  li
    []
    [ text bucket.name
    , Routes.linkTo (Routes.BucketDetailPage bucket.id)
        []
        [ text "Edit" ]
    , button
        [ onClick <| DeleteBucket (.id bucket) ]
        [ text "Delete!" ]
    ]
