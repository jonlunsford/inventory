defmodule Inventory.BucketsController do
  use Inventory.Web, :controller

  alias Inventory.Bucket
  alias Inventory.ErrorHelpers

  def index(conn, _params) do
    render conn, "index.html", buckets: Repo.all(Bucket)
  end

  def new(conn, _params) do
    changeset = Bucket.changeset(%Bucket{})
    render conn, "new.html", changeset: changeset
  end

  def show(conn, %{"id" => id}) do
    bucket = Repo.get(Bucket, id) |> Repo.preload(:products)
    render conn, "show.html", bucket: bucket
  end

  def edit(conn, %{"id" => id}) do
    bucket = Repo.get(Bucket, id) |> Repo.preload(:products)
    changeset = Bucket.changeset(bucket)
    render conn, "edit.html", changeset: changeset
  end

  def create(conn, %{"bucket" => bucket_params}) do
    changeset = Bucket.changeset(%Bucket{}, bucket_params)

    case Repo.insert(changeset) do
      {:ok, bucket} ->
        conn
        |> put_flash(:info, "Bucket created successfully!")
        |> render("show.html", id: bucket.id, bucket: (bucket |> Repo.preload(:products)))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "There were errors creating your bucket.")
        |> render("new.html", changeset: changeset, errors: Ecto.Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1))
    end
  end

  def update(conn, %{"id" => id, "bucket" => bucket_params}) do
    bucket = Repo.get(Bucket, id)
    changeset = Bucket.changeset(bucket, bucket_params)

    case Repo.update(changeset) do
      {:ok, bucket} ->
        conn
        |> render("show.html", bucket: (bucket |> Repo.preload(:products)))
      {:error, changeset} ->
        conn
        |> render("show.html", bucket: (changeset.data |> Repo.preload(:products)), errors: Ecto.Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1))
    end
  end

  def delete(conn, %{"id" => id}) do
    bucket = Repo.get!(Bucket, id)

    case Repo.delete(bucket) do
      {:ok, _bucket} ->
        redirect conn, to: "/buckets"
      {:error, changeset} ->
        render conn, "show.html", bucket: changeset.data, errors: Ecto.Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)
    end
  end
end
