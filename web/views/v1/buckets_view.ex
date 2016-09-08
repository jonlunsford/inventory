defmodule Inventory.V1.BucketsView do
  use Inventory.Web, :view

  def render("index.json", %{ buckets: buckets }) do
   %{ buckets: render_many(buckets, Inventory.V1.BucketsView, "show.json", as: :bucket) }
  end

  def render("show.json", %{ bucket: bucket }) do
   render_one(bucket, Inventory.V1.BucketsView, "bucket.json", as: :bucket)
  end

  def render("bucket.json", %{ bucket: bucket }) do
    %{ id: bucket.id, name: bucket.name }
  end

  def render("bucket_with_products.json", %{ bucket: bucket } ) do
    products = Inventory.V1.ProductsView.render("index.json", products: bucket.products)

    %{ id: bucket.id, name: bucket.name }
    |> Map.put(:products, products[:products])
  end
end
