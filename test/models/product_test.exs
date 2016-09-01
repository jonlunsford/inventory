defmodule Inventory.ProductTest do
  use Inventory.ModelCase

  alias Inventory.Product

  @valid_attrs %{title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Product.changeset(%Product{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Product.changeset(%Product{}, @invalid_attrs)
    refute changeset.valid?
  end

end

defmodule Inventory.Product.InsertTest do
  use ExUnit.Case
  use Inventory.ConnCase

  setup do
    product = %Inventory.Product{title: "Mac n Cheese"} |> Inventory.Repo.insert!
    bucket = %Inventory.Bucket{name: "Edibals"} |> Inventory.Repo.insert!

    %Inventory.ProductBucket{
      product_id: product.id,
      bucket_id: bucket.id
    } |> Inventory.Repo.insert!

    { :ok, bucket_id: bucket.id, product_id: product.id  }
  end

  test "product added to bucket", context do
    product = Inventory.Product
      |> Inventory.Repo.get(context[:product_id])
      |> Inventory.Repo.preload(:buckets)

    assert product.title == "Mac n Cheese"
    assert Enum.count(product.buckets) == 1
  end

  test "bucket added to product", context do
    bucket = Inventory.Bucket
      |> Inventory.Repo.get(context[:bucket_id])
      |> Inventory.Repo.preload(:products)

    assert bucket.name == "Edibals"
    assert Enum.count(bucket.products) == 1
  end

end
