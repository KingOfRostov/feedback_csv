defmodule FeedbackCsv.Reviews do
  import Ecto.Query, warn: false

  alias FeedbackCsv.Repo
  alias FeedbackCsv.Reviews.Author
  alias FeedbackCsv.Reviews.Review

  def list_review do
    Repo.all(Review) |> Repo.preload(:author)
  end
end
