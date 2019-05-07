defmodule FeedbackCsvWeb.ReviewController do
  use FeedbackCsvWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
