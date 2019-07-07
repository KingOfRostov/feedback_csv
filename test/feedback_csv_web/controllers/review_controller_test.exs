defmodule FeedbackCsvWeb.ReviewControllerTest do
  use FeedbackCsvWeb.ConnCase

  test "GET /reviews", %{conn: conn} do
    conn = get(conn, "/reviews")
    assert html_response(conn, 200) =~ "Отзывов в базе данных"
  end

  test "POST /reviews", %{conn: conn} do
    conn = post(conn, "/reviews")
    assert redirected_to(conn) == Routes.review_path(conn, :index)
  end
end
