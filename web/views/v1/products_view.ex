defmodule Inventory.V1.ProductsView do
  use Inventory.Web, :view

  def render("index.json", %{ products: products }) do
   %{ products: render_many(products, Inventory.V1.ProductsView, "show.json", as: :product) }
  end

  def render("show.json", %{ product: product }) do
   render_one(product, Inventory.V1.ProductsView, "product.json", as: :product)
  end

  def render("product.json", %{ product: product }) do
    %{ id: product.id, title: product.title }
  end
end
