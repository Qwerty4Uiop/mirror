defmodule MirrorWeb.Router do
  use MirrorWeb, :router

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

  scope "/", MirrorWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/calc", CalcController, :index
    get "/calc/:currency", CalcController, :calculate
  end

  # Other scopes may use custom stacks.
  # scope "/api", MirrorWeb do
  #   pipe_through :api
  # end
end
