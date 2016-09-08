defmodule Inventory.Product do
  use Inventory.Web, :model

  schema "products" do
    field :title, :string

    has_many :products_buckets, Inventory.ProductBucket
    has_many :buckets, through: [:products_buckets, :bucket]

    has_many :products_fields, Inventory.ProductField
    has_many :fields, through: [:products_fields, :field]

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end
