defmodule Inventory.Repo.Migrations.MakeProductsBucketsIndexUnique do
  use Ecto.Migration

  def change do
    create index(:products_buckets, [:product_id, :bucket_id], unique: true)
  end
end
