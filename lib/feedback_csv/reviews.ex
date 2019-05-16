defmodule FeedbackCsv.Reviews do
  alias FeedbackCsv.CsvLoader
  alias FeedbackCsv.ReviewQueries

  def list_review(), do: ReviewQueries.list_review()

  def load_from_csv(filename) do
    case prepare_csv_to_db(filename) do
      {:ok, data} ->
        csv_to_db(data)
        :ok

      :error ->
        :error
    end
  end

  def change_review(), do: ReviewQueries.change_review()

  def change_review(review, attrs),
    do: ReviewQueries.change_review(review, attrs)

  def create_review(attrs), do: ReviewQueries.create_review(attrs)

  defp prepare_csv_to_db(filename), do: CsvLoader.prepare_csv_to_db(filename)

  defp csv_to_db(data), do: ReviewQueries.csv_to_db(data)
end
