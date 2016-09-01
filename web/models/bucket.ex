defmodule Inventory.Bucket do
  use Inventory.Web, :model

  schema "buckets" do
    field :name, :string

    has_many :products_buckets, Inventory.ProductBucket
    has_many :products, through: [:products_buckets, :product]

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
