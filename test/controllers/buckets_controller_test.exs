defmodule Inventory.BucketsControllerTest do
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

    %ProductBucket{
      product_id: product.id,
      bucket_id: bucket.id
    } |> Inventory.Repo.insert!

    on_exit fn ->
      Ecto.Adapters.SQL.Sandbox.checkout(Inventory.Repo)

      Inventory.Repo.delete_all(Bucket)
      Inventory.Repo.delete_all(Product)
      Inventory.Repo.delete_all(ProductBucket)
    end

    { :ok, id: bucket.id, name: bucket.name  }
  end

  test "GET /buckets", context do
    conn = get build_conn, "/buckets"
    bucket = hd(conn.assigns[:buckets])
    assert bucket.name == context[:name]
  end

  test "GET /buckets/new" do
    conn = get build_conn, "/buckets/new"
    assert conn.assigns[:changeset] == Bucket.changeset(%Bucket{})
  end

  test "GET /buckets/:id", context do
    conn = get build_conn, "/buckets/#{context[:id]}"
    assert conn.assigns[:bucket].name == context[:name]
  end

  test "GET /buckets/:id with products", context do
    conn = get build_conn, "/buckets/#{context[:id]}"
    assert hd(conn.assigns[:bucket].products).title == "My Product"
  end

  test "GET /buckets/:id/edit", context do
    conn = get build_conn, "/buckets/#{context[:id]}/edit"
    assert conn.assigns[:changeset].data.name == context[:name]
  end

  test "POST /buckets with valid attributes", %{ conn: conn } do
    conn = post conn, "/buckets", %{ bucket: %{ name: "New Bucket" } }
    assert conn.assigns[:bucket].name == "New Bucket"
  end

  test "POST /buckets with invalid attributes", %{ conn: conn } do
    conn = post conn, "/buckets", %{ bucket: %{ name: "" } }
    assert hd(conn.assigns[:errors][:name]) == "can't be blank"
  end

  test "PUT /buckets with valid attributes", context do
    conn = put build_conn, "/buckets/#{context[:id]}", %{ bucket: %{ name: "Edit Name" } }
    assert conn.assigns[:bucket].name == "Edit Name"
  end

  test "PUT /buckets with invalid attributes", context do
    conn = put build_conn, "/buckets/#{context[:id]}", %{ bucket: %{ name: "" } }
    assert hd(conn.assigns[:errors][:name]) == "can't be blank"
  end

  test "DELETE /buckets", context do
    conn = delete build_conn, "/buckets/#{context[:id]}"
    assert conn.status == 302
  end
end
