module ServerClient exposing(..)

import Json.Decode as JsonD exposing((:=))
import Json.Encode as JsonE
import Http
import Task

type alias Bucket =
  { id : Int
  , companyId : Int
  , name : String
  }

type alias BucketRequest a =
  { a
      | id : Int
      , companyId : Int
      , name : String
  }

baseUrl : String
baseUrl =
  "http://localhost:4000/api/v1"


getBucket : Int -> (Http.Error -> msg) -> (Bucket -> msg) -> Cmd msg
getBucket id errorMsg msg =
  Http.get bucketDecoder (baseUrl ++ "/buckets/" ++ toString id)
      |> Task.perform errorMsg msg


getBuckets : (Http.Error -> msg) -> (List Bucket -> msg) -> Cmd msg
getBuckets errorMsg msg =
  Http.get bucketsDecoder (baseUrl ++ "/buckets")
      |> Task.perform errorMsg msg


createBucket : BucketRequest a -> (Http.Error -> msg) -> (Bucket -> msg) -> Cmd msg
createBucket bucket errorMsg msg =
  Http.send Http.defaultSettings
      { verb = "POST"
      , url = baseUrl ++ "/buckets"
      , body = Http.string (encodeBucket bucket)
      , headers = [ ( "Content-Type", "application/json" ) ]
      }
      |> Http.fromJson bucketDecoder
      |> Task.perform errorMsg msg


deleteBucket : Int -> msg -> msg -> Cmd msg
deleteBucket id errorMsg msg =
  Http.send Http.defaultSettings
      { verb = "DELETE"
      , url = baseUrl ++ "/buckets/" ++ toString id
      , body = Http.empty
      , headers = []
      }
      |> Task.perform (\_ -> errorMsg) (\_ -> msg)


bucketDecoder : JsonD.Decoder Bucket
bucketDecoder =
  JsonD.object3 Bucket
    ("id" := JsonD.int)
    ("companyId" := JsonD.int)
    ("name" := JsonD.string)


bucketsDecoder : JsonD.Decoder (List Bucket)
bucketsDecoder =
  JsonD.list bucketDecoder


encodeBucket : BucketRequest a -> String
encodeBucket a =
  JsonE.encode 0
      <| JsonE.object
          [ ("id", JsonE.int a.id)
          , ("name", JsonE.string a.name)
          , ("companyId", JsonE.int a.companyId)
          ]
