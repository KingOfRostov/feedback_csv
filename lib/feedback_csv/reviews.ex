defmodule FeedbackCsv.Reviews do
  alias FeedbackCsv.CsvLoader
  alias FeedbackCsv.ReviewQueries

  def list_review(), do: ReviewQueries.list_review()

  @url "https://apis.paralleldots.com/v4/emotion"
  @api_key "PTEazLkKberIZlwBBBykxww77Bn9z6dxUMJAJL7AOeQ"
  def get_emotion(text) do
    body = Jason.encode(%{"text" => text, "api_key" => @api_key}) |> Kernel.elem(1)
    HTTPoison.post(@url, body)
  end

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

  # Возвращает название месяца по порядковому номеру
  def get_month(number) do
    case number do
      1 -> "JANUARY"
      2 -> "FEBRUARY"
      3 -> "MARCH"
      4 -> "APRIL"
      5 -> "MAY"
      6 -> "JUNE"
      7 -> "JULY"
      8 -> "AUGUST"
      9 -> "SEPTEMBER"
      10 -> "OCTOBER"
      11 -> "NOVEMBER"
      12 -> "DECEMBER"
    end
  end

  # Возвращает время суток по порядковому номеру
  def get_time(number) do
    cond do
      Enum.find(5..11, &(&1 == number)) != nil -> "УТРО"
      Enum.find(12..17, &(&1 == number)) != nil -> "ДЕНЬ"
      Enum.find(18..23, &(&1 == number)) != nil -> "ВЕЧЕР"
      Enum.find([24, 0, 1, 2, 3, 4], &(&1 == number)) != nil -> "НОЧЬ"
    end
  end
end
