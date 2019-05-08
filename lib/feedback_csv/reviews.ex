defmodule FeedbackCsv.Reviews do
  alias FeedbackCsv.Repo
  alias FeedbackCsv.Reviews.Review

  # Список всех отзывов в базе
  def list_review do
    Repo.all(Review) |> Repo.preload(:author)
  end
end
