defmodule FeedbackCsv.ReviewQueries do
  alias FeedbackCsv.Repo
  alias FeedbackCsv.Reviews.Review

  # Загружает данные из .csv файла в БД
  def csv_to_db(map) do
    Enum.map(map, &put_author_and_review/1)
  end

  # Список всех отзывов в базе
  def list_review do
    Review
    |> Repo.all()
    |> Repo.preload(:author)
  end

  # Получает структуры Отзыва и Автора
  defp put_author_and_review(map) do
    author_map = map.author
    review_map = map.review

    review_map = Map.merge(review_map, %{author: author_map})
    create_review(review_map)
  end

  # Создает отзыв в БД
  def create_review(attrs) do
    %Review{}
    |> change_review(attrs)
    |> Repo.insert()
  end

  # Возвращает Review changeset
  def change_review(review \\ %Review{}, attrs \\ %{}), do: Review.changeset(review, attrs)
end
