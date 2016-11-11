defmodule Inventory.Api.V1.ProductsControllerTest do
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

    { :ok, id: product.id, title: product.title, bucket_id: bucket.id  }
  end

  test "GET /api/v1/products", context do
    conn = get build_conn(), "/api/v1/products"
    products = json_response(conn, 200)["products"]
    assert hd(products)["title"] == context[:title]
  end

  test "GET /api/v1/products/:id", context do
    conn = get build_conn(), "/api/v1/products/#{context[:id]}"
    product = json_response(conn, 200)
    assert product["id"] == context[:id]
  end

  test "POST /api/v1/products with valid attributes", %{ conn: conn } do
    conn = post conn, "/api/v1/products", %{ product: %{ title: "New Product" }}
    response = json_response(conn, 200)
    assert response["title"] == "New Product"
  end

  test "POST /api/v1/products with associated bucket", context do
    post build_conn(), "api/v1/products", %{ product: %{ title: "With Bucket", bucket_id: context[:bucket_id] } }

    product = Inventory.Product |> preload(:products_buckets) |> last |> Repo.one
    assoc = List.last(product.products_buckets)

    assert assoc.bucket_id == context[:bucket_id]
    assert assoc.product_id == product.id
  end

  test "POST /api/v1/products with invalid attributes", %{ conn: conn } do
    conn = post conn, "/api/v1/products", %{ product: %{ title: "" }}
    response = json_response(conn, 200)
    assert hd(response["errors"]["title"]) == "can't be blank"
  end

  test "PUT /api/v1/products with valid attributes", context do
    conn = put build_conn(), "/api/v1/products/#{context[:id]}", %{ product: %{ title: "Edit title" }}
    response = json_response(conn, 200)
    assert response["title"] == "Edit title"
  end

  test "PUT /api/v1/products with invalid attributes", context do
    conn = put build_conn(), "/api/v1/products/#{context[:id]}", %{ product: %{ title: "" }}
    response = json_response(conn, 200)
    assert hd(response["errors"]["title"]) == "can't be blank"
  end

  test "DELETE /api/v1/products", context do
    conn = delete build_conn(), "/api/v1/products/#{context[:id]}"
    response = json_response(conn, 200)
    assert response["deleted"] == true
  end

end
