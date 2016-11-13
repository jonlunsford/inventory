defmodule Inventory.ProductsController do
  use Inventory.Web, :controller

  alias Inventory.Product
  alias Inventory.Bucket
  alias Inventory.ProductBucket
  alias Inventory.ErrorHelpers

  def index(conn, _params) do
    render conn, "index.html", products: Repo.all(Product)
  end

  def new(conn, _params) do
    changeset = Product.changeset(%Product{})
    buckets = Repo.all(Bucket)
    product_buckets = [%ProductBucket{}]
    render conn, "new.html", changeset: changeset, buckets: buckets, product_buckets: product_buckets
  end

  def show(conn, %{"id" => id}) do
    product = Repo.get!(Product, id) |> Repo.preload(:buckets)
    render conn, "show.html", product: product
  end

  def edit(conn, %{"id" => id}) do
    product = Repo.get(Product, id) |> Repo.preload(:buckets)
    buckets = Repo.all(Bucket)
    changeset = Product.changeset(product)
    product_buckets = Repo.all(ProductBucket, product_id: id)
    render conn, "edit.html", changeset: changeset, buckets: buckets, product_buckets: product_buckets
  end

  def create(conn, %{"product" => product_params}) do
    changeset = Product.changeset(%Product{}, product_params)

    case Repo.insert(changeset) do
      {:ok, product} ->
        product |> associate_buckets(product_params)
        render(conn, "show.html", product: (product |> Repo.preload(:buckets)))
      {:error, changeset} ->
        render conn, "show.html", product: changeset.data, errors: Ecto.Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)
    end
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Repo.get!(Product, id)
    changeset = Product.changeset(product, product_params)

    case Repo.update(changeset) do
      {:ok, product} ->
        product |> associate_buckets(product_params)
        render(conn, "show.html", product: (product |> Repo.preload(:buckets)))
      {:error, changeset} ->
        render conn, "show.html", product: changeset.data, errors: Ecto.Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Repo.get!(Product, id)

    case Repo.delete(product) do
      {:ok, _product} ->
        Repo.delete_all(ProductBucket |> where(product_id: ^id))
        redirect conn, to: "/products"
      {:error, changeset} ->
        render conn, "show.html", product: changeset.data, errors: Ecto.Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)
    end
  end

  defp associate_buckets(product, %{"bucket_ids" => ids}) when length(ids) > 0 do
    Repo.delete_all(ProductBucket |> where(product_id: ^product.id))

    ids
    |> Enum.each(fn(bucket_id) ->
      assoc = ProductBucket.changeset(%ProductBucket{}, %{ bucket_id: bucket_id, product_id: product.id })
      Repo.insert(assoc)
    end)
  end

  defp associate_buckets(product, %{"bucket_ids" => ids}) when length(ids) == 0 do
    Repo.delete_all(ProductBucket |> where(product_id: ^product.id))
  end

  defp associate_buckets(_, _), do: :noop

end
