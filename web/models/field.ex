defmodule Inventory.Field do
  use Inventory.Web, :model

  schema "fields" do
    field :label, :string
    field :name, :string
    field :type, :string
    field :boolean_value, :boolean, default: false
    field :content_value, :string
    field :options_value, :map
    field :text_value, :string
    field :date_value, Ecto.DateTime
    field :integer_value, :integer

    has_many :products_fields, Inventory.ProductField
    has_many :products, through: [:products_fields, :product]

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:label, :name, :type, :boolean_value, :content_value, :options_value, :text_value, :date_value, :integer_value])
    |> validate_required([:label, :type])
  end
end
