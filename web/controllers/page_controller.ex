defmodule Inventory.PageController do
  use Inventory.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
