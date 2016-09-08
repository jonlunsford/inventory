defmodule Inventory.ProductField do
  use Inventory.Web, :model

  schema "products_fields" do
    belongs_to :product, Inventory.Product
    belongs_to :field, Inventory.Field

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:product_id, :field_id])
    |> validate_required([:product_id, :field_id])
  end
end
