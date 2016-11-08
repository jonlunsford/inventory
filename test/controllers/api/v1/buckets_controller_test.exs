defmodule Inventory.Api.V1.BucketsControllerTest do
  use ExUnit.Case
  use Inventory.ConnCase

  setup do
    bucket =
      %Inventory.Bucket{name: "My Bucket"}
      |> Inventory.Repo.insert!

    product =
      %Inventory.Product{title: "My Product"}
      |> Inventory.Repo.insert!

    %Inventory.ProductBucket{
      product_id: product.id,
      bucket_id: bucket.id
    } |> Inventory.Repo.insert!

    { :ok, id: bucket.id, name: bucket.name  }
  end

  test "GET /api/v1/buckets", context do
    conn = get build_conn(), "/api/v1/buckets"
    buckets = json_response(conn, 200)["buckets"]
    assert hd(buckets)["name"] == context[:name]
  end

  test "GET /api/v1/buckets/:id", context do
    conn = get build_conn(), "/api/v1/buckets/#{context[:id]}"
    bucket = json_response(conn, 200)
    assert bucket["id"] == context[:id]
  end

  test "GET /api/v1/buckets/:id with products", context do
    conn = get build_conn(), "/api/v1/buckets/#{context[:id]}"
    bucket = json_response(conn, 200)
    assert hd(bucket["products"])["title"] == "My Product"
  end

  test "POST /api/v1/buckets with valid attributes", %{ conn: conn } do
    conn = post conn, "/api/v1/buckets", %{ bucket: %{ name: "New Bucket" }}
    response = json_response(conn, 200)
    assert response["name"] == "New Bucket"
  end

  test "POST /api/v1/buckets with invalid attributes", %{ conn: conn } do
    conn = post conn, "/api/v1/buckets", %{ bucket: %{ name: "" }}
    response = json_response(conn, 200)
    assert hd(response["errors"]["name"]) == "can't be blank"
  end

  test "PUT /api/v1/buckets with valid attributes", context do
    conn = put build_conn(), "/api/v1/buckets/#{context[:id]}", %{ bucket: %{ name: "Edit Name" }}
    response = json_response(conn, 200)
    assert response["name"] == "Edit Name"
  end

  test "PUT /api/v1/buckets with invalid attributes", context do
    conn = put build_conn(), "/api/v1/buckets/#{context[:id]}", %{ bucket: %{ name: "" }}
    response = json_response(conn, 200)
    assert hd(response["errors"]["name"]) == "can't be blank"
  end

  test "DELETE /api/v1/buckets", context do
    conn = delete build_conn(), "/api/v1/buckets/#{context[:id]}"
    response = json_response(conn, 200)
    assert response["deleted"] == true
  end

end
