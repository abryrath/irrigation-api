defmodule IriWeb.Router do
  use IriWeb, :router

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

  scope "/", IriWeb do
    pipe_through :api

    get "/records/latest", RecordsController, :latest
    get "/forecast/today", ForecastController, :today

    post "/sprinkler/default", SprinklerController, :default
    post "/sprinkler/custom", SprinklerController, :custom
  end

  # Other scopes may use custom stacks.
  # scope "/api", IriWeb do
  #   pipe_through :api
  # end
end
