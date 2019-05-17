defmodule FeedbackCsv.Reviews do
  alias FeedbackCsv.CsvLoader
  alias FeedbackCsv.ReviewQueries

  def list_review(), do: ReviewQueries.list_review()

  # Загружает данные из .csv файла в БД
  def load_from_csv(filename) do
    case CsvLoader.prepare_csv_to_db(filename) do
      {:ok, data} ->
        ReviewQueries.csv_to_db(data)
        :ok

      :error ->
        :error
    end
  end

  # Возвращает changeset 
  def change_review(review, attrs),
    do: ReviewQueries.change_review(review, attrs)

  def change_review(), do: ReviewQueries.change_review()

  # Создает отзыв в БД
  def create_review(attrs), do: ReviewQueries.create_review(attrs)
end
