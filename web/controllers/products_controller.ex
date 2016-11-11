defmodule Inventory.ProductsController do
  use Inventory.Web, :controller

  alias Inventory.Product
  alias Inventory.ErrorHelpers

  def index(conn, _params) do
    render conn, "index.html", products: Repo.all(Product)
  end

  def new(conn, _params) do
    changeset = Product.changeset(%Product{})
    render conn, "new.html", changeset: changeset
  end

  def show(conn, %{"id" => id}) do
    product = Repo.get!(Product, id) |> Repo.preload(:buckets)
    render conn, "show.html", product: product
  end

  def edit(conn, %{"id" => id}) do
    bucket = Repo.get(Product, id) |> Repo.preload(:buckets)
    changeset = Product.changeset(bucket)
    render conn, "edit.html", changeset: changeset
  end

  def create(conn, %{"product" => product_params}) do
    changeset = Product.changeset(%Product{}, product_params)

    case Repo.insert(changeset) do
      {:ok, product} ->
        render conn, "show.html", product: product
      {:error, changeset} ->
        render conn, "show.html", product: changeset.data, errors: Ecto.Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)
    end
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Repo.get!(Product, id)
    changeset = Product.changeset(product, product_params)

    case Repo.update(changeset) do
      {:ok, product} ->
        render conn, "show.html", product: product
      {:error, changeset} ->
        render conn, "show.html", product: changeset.data, errors: Ecto.Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Repo.get!(Product, id)

    case Repo.delete(product) do
      {:ok, _product} ->
        redirect conn, to: "/products"
      {:error, changeset} ->
        render conn, "show.html", product: changeset.data, errors: Ecto.Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)
    end
  end

end
