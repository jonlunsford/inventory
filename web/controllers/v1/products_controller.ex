defmodule Inventory.V1.ProductsController do
  use Inventory.Web, :controller

  alias Inventory.Product
  alias Inventory.ProductBucket

  def index(conn, _params) do
    render conn, "index.json", products: Repo.all(Product)
  end

  def show(conn, %{"id" => id}) do
    product = Repo.get!(Product, id)
    render conn, "show.json", product: product
  end

  def create(conn, %{"product" => product_params}) do
    changeset = Product.changeset(%Product{}, product_params)

    case Repo.insert(changeset) do
      {:ok, product} ->
        product
        |> associate_bucket(product_params)

        render conn, "show.json", product: product
      {:error, changeset} ->
        json(conn,  %{ errors: Ecto.Changeset.traverse_errors(changeset, &Inventory.ErrorHelpers.translate_error/1) })
    end
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Repo.get!(Product, id)
    changeset = Product.changeset(product, product_params)

    case Repo.update(changeset) do
      {:ok, product} ->
        render conn, "show.json", product: product
      {:error, changeset} ->
        json(conn,  %{ errors: Ecto.Changeset.traverse_errors(changeset, &Inventory.ErrorHelpers.translate_error/1) })
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Repo.get!(Product, id)
    Repo.delete!(product)
    json(conn, %{ deleted: true })
  end

  def associate_bucket(product, params) do
    ProductBucket.changeset(%ProductBucket{}, %{ product_id: product.id, bucket_id: params["bucket_id"] })
    |> Repo.insert
  end

end
