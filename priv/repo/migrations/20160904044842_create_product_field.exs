defmodule Inventory.Repo.Migrations.CreateProductField do
  use Ecto.Migration

  def change do
    create table(:product_fields) do
      add :product_id, references(:products, on_delete: :nothing)
      add :field_id, references(:fields, on_delete: :nothing)

      timestamps()
    end
    create index(:product_fields, [:product_id])
    create index(:product_fields, [:field_id])

  end
end
