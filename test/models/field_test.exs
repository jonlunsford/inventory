defmodule Inventory.FieldTest do
  use Inventory.ModelCase

  alias Inventory.Field

  @valid_attrs %{boolean_value: true, content_value: "some content", date_value: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, integer_value: 42, label: "some content", name: "some content", options_value: %{}, text_value: "some content", type: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Field.changeset(%Field{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Field.changeset(%Field{}, @invalid_attrs)
    refute changeset.valid?
  end
end

defmodule Inventory.Field.InsertTest do
  use ExUnit.Case
  use Inventory.ConnCase

  setup do
    product = %Inventory.Product{title: "Mac n Cheese"} |> Inventory.Repo.insert!
    field = %Inventory.Field{name: "My Text Field"} |> Inventory.Repo.insert!

    %Inventory.ProductField{
      product_id: product.id,
      field_id: field.id
    } |> Inventory.Repo.insert!

    { :ok, product_id: product.id, field_id: field.id  }
  end

  test "product added to field", context do
    product = Inventory.Product
      |> Inventory.Repo.get(context[:product_id])
      |> Inventory.Repo.preload(:fields)

    assert product.title == "Mac n Cheese"
    assert Enum.count(product.fields) == 1
  end

  test "field added to product", context do
    field = Inventory.Field
      |> Inventory.Repo.get(context[:field_id])
      |> Inventory.Repo.preload(:products)

    assert field.name == "My Text Field"
    assert Enum.count(field.products) == 1
  end

end
