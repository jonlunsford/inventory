defmodule Inventory.ProductBucket do
  use Inventory.Web, :model

  schema "products_buckets" do
    belongs_to :product, Inventory.Product
    belongs_to :bucket, Inventory.Bucket

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:product_id, :bucket_id])
    |> validate_required([:product_id, :bucket_id])
  end
end
