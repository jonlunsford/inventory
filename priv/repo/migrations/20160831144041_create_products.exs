defmodule Inventory.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products_buckets) do
      add :product_id, :integer
      add :bucket_id, :integer

      timestamps
    end

    create table(:products) do
      add :title, :string

      timestamps
    end
  end
end
