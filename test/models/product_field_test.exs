defmodule Inventory.ProductFieldTest do
  use Inventory.ModelCase

  alias Inventory.ProductField

  @valid_attrs %{product_id: 1, field_id: 2}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ProductField.changeset(%ProductField{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ProductField.changeset(%ProductField{}, @invalid_attrs)
    refute changeset.valid?
  end
end

