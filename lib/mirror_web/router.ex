defmodule MirrorWeb.Router do
  use MirrorWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", MirrorWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/calc", CalcController, :index
    get "/calc/:currency", CalcController, :calculate
  end
end
