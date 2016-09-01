defmodule Inventory.ProductBucketTest do
  use Inventory.ModelCase

  alias Inventory.ProductBucket

  @valid_attrs %{product_id: 1, bucket_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ProductBucket.changeset(%ProductBucket{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ProductBucket.changeset(%ProductBucket{}, @invalid_attrs)
    refute changeset.valid?
  end
end
