defmodule FeedbackCsv.ReviewQueries do
  alias FeedbackCsv.Repo
  alias FeedbackCsv.Reviews.Review
  alias FeedbackCsv.Reviews.Author

  # Загружает данные из .csv файла в БД
  def csv_to_db(map) do
    Enum.map(map, &put_author_and_review/1)
  end

  # Список всех отзывов в базе
  def list_review do
    Repo.all(Review) |> Repo.preload(:author)
  end

  # Получаем структуры Отзыва и Автора
  defp put_author_and_review(map) do
    author_map = map.author
    review_map = map.review

    review_map = Map.merge(review_map, %{author: author_map})
    create_review(review_map)
  end

  defp create_review(attrs) do
    %Review{}
    |> change_review(attrs)
    |> Repo.insert()
  end

  defp change_review(review, attrs), do: Review.changeset(review, attrs)
end
