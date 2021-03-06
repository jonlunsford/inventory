defmodule Inventory.Router do
  use Inventory.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Inventory do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/buckets", BucketsController
    resources "/products", ProductsController
  end

  # Other scopes may use custom stacks.
  scope "/api", Inventory.Api, as: :api do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      resources "/buckets", BucketsController
      resources "/products", ProductsController
    end
  end
end
