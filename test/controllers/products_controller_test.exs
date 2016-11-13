defmodule Inventory.ProductsControllerTest do
  use ExUnit.Case
  use Inventory.ConnCase

  alias Inventory.Bucket
  alias Inventory.Product
  alias Inventory.ProductBucket

  setup do
    bucket =
      %Bucket{name: "My Bucket"}
      |> Inventory.Repo.insert!

    product =
      %Product{title: "My Product"}
      |> Inventory.Repo.insert!

    %Inventory.ProductBucket{
      product_id: product.id,
      bucket_id: bucket.id
    } |> Inventory.Repo.insert!

    on_exit fn ->
      Ecto.Adapters.SQL.Sandbox.checkout(Inventory.Repo)

      Inventory.Repo.delete_all(Bucket)
      Inventory.Repo.delete_all(Product)
      Inventory.Repo.delete_all(ProductBucket)
    end

    { :ok, id: product.id, title: product.title, bucket_id: bucket.id  }
  end

  test "GET /products", context do
    conn = get build_conn, "/products"
    product = hd(conn.assigns[:products])
    assert product.title == context[:title]
  end

  test "GET /products/new" do
    conn = get build_conn, "/products/new"
    assert conn.assigns[:changeset] == Product.changeset(%Product{})
  end

  test "GET /products/:id", context do
    conn = get build_conn, "/products/#{context[:id]}"
    assert conn.assigns[:product].title == context[:title]
  end

  test "GET /products/:id with buckets", context do
    conn = get build_conn, "/products/#{context[:id]}"
    assert hd(conn.assigns[:product].buckets).name == "My Bucket"
  end

  test "GET /products/:id/edit", context do
    conn = get build_conn, "/products/#{context[:id]}/edit"
    assert conn.assigns[:changeset].data.title == context[:title]
  end

  test "POST /products with a new bucket", %{ conn: conn } do
    bucket =
      %Bucket{name: "New Bucket"}
      |> Inventory.Repo.insert!

    conn = post conn, "/products", %{ product: %{ title: "New One", bucket_id: bucket.id } }
    assert hd(conn.assigns[:product].buckets).id == bucket.id
  end

  test "POST /products with valid attributes", %{ conn: conn } do
    conn = post conn, "/products", %{ product: %{ title: "New product" } }
    assert conn.assigns[:product].title == "New product"
  end

  test "POST /products with invalid attributes", %{ conn: conn } do
    conn = post conn, "/products", %{ product: %{ title: "" } }
    assert hd(conn.assigns[:errors][:title]) == "can't be blank"
  end

  test "PUT /products with valid attributes", context do
    conn = put build_conn, "/products/#{context[:id]}", %{ product: %{ title: "Edit title" } }
    assert conn.assigns[:product].title == "Edit title"
  end

  test "PUT /products with invalid attributes", context do
    conn = put build_conn, "/products/#{context[:id]}", %{ product: %{ title: "" } }
    assert hd(conn.assigns[:errors][:title]) == "can't be blank"
  end

  test "DELETE /products", context do
    conn = delete build_conn, "/products/#{context[:id]}"
    assert conn.status == 302
  end
end
