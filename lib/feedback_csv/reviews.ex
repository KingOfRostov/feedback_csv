defmodule FeedbackCsv.Reviews do
  import Ecto.Query

  alias FeedbackCsv.Repo
  alias FeedbackCsv.Reviews.Review

  # Список всех отзывов в базе
  def list_review do
    Repo.all(Review) |> Repo.preload(:author)
  end

  def sort_by(sort_param) do
    query = from(r in Review, where: r.city == "Ростов-на-Дону")
    Repo.all(query) |> Repo.preload(:author)
  end
end
