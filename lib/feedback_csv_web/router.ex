defmodule FeedbackCsvWeb.Router do
  use FeedbackCsvWeb, :router

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

  scope "/", FeedbackCsvWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/reviews", ReviewController, only: [:index, :create]
    get "/reviews/html", ReviewController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", FeedbackCsvWeb do
  #   pipe_through :api
  # end
end
