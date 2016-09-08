defmodule Inventory.Repo.Migrations.CreateField do
  use Ecto.Migration

  def change do
    create table(:fields) do
      add :label, :string
      add :name, :string
      add :type, :string
      add :boolean_value, :boolean, default: false, null: false
      add :content_value, :text
      add :options_value, :map
      add :text_value, :string
      add :date_value, :datetime
      add :integer_value, :integer

      timestamps()
    end

  end
end
