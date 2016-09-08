defmodule Inventory.Repo.Migrations.AddIndexesToProductBuckets do
  use Ecto.Migration

  def change do
    create index(:products_buckets, [:product_id])
    create index(:products_buckets, [:bucket_id])
  end
end
