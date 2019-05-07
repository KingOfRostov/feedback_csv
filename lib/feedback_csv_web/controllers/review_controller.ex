defmodule FeedbackCsvWeb.ReviewController do
  use FeedbackCsvWeb, :controller

  def index(conn, _params) do
    reviews = FeedbackCsv.Reviews.list_review()

    render(conn, "index.html", reviews: reviews)
  end
end
