defmodule Inventory.Repo.Migrations.RenameProductFieldsToProductsFields do
  use Ecto.Migration

  def change do
    rename table(:product_fields), to: table(:products_fields)

    create index(:products_fields, [:product_id])
    create index(:products_fields, [:field_id])

  end
end
