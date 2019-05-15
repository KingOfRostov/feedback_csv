defmodule FeedbackCsv.Reviews do
  import Ecto.Query

  alias FeedbackCsv.Repo
  alias FeedbackCsv.Reviews.Review
  alias FeedbackCsv.CsvLoader
  alias FeedbackCsv.ReviewQueries

  def list_review(), do: ReviewQueries.list_review()

  def prepare_csv_to_db(filename), do: CsvLoader.prepare_csv_to_db(filename)

  def csv_to_db(data), do: ReviewQueries.csv_to_db(data)
end
