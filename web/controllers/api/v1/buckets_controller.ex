defmodule Inventory.Api.V1.BucketsController do
  use Inventory.Web, :controller

  alias Inventory.Bucket
  alias Inventory.ErrorHelpers

  def index(conn, _params) do
    render conn, "index.json", buckets: Repo.all(Bucket)
  end

  def show(conn, %{"id" => id}) do
    bucket = Repo.get!(Bucket, id) |> Repo.preload(:products)
    render conn, "bucket_with_products.json", bucket: bucket
  end

  def create(conn, %{"bucket" => bucket_params}) do
    changeset = Bucket.changeset(%Bucket{}, bucket_params)

    case Repo.insert(changeset) do
      {:ok, bucket} ->
        render conn, "show.json", bucket: bucket
      {:error, changeset} ->
        json(conn,  %{ errors: Ecto.Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1) })
    end
  end

  def update(conn, %{"id" => id, "bucket" => bucket_params}) do
    bucket = Repo.get!(Bucket, id)
    changeset = Bucket.changeset(bucket, bucket_params)

    case Repo.update(changeset) do
      {:ok, bucket} ->
        render conn, "show.json", bucket: bucket
      {:error, changeset} ->
        json(conn,  %{ errors: Ecto.Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1) })
    end
  end

  def delete(conn, %{"id" => id}) do
    bucket = Repo.get!(Bucket, id)
    Repo.delete!(bucket)
    json(conn, %{ deleted: true })
  end

end
