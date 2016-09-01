defmodule Inventory.BucketTest do
  use Inventory.ModelCase

  alias Inventory.Bucket

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Bucket.changeset(%Bucket{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Bucket.changeset(%Bucket{}, @invalid_attrs)
    refute changeset.valid?
  end
end
