defmodule FeedbackCsv.Reviews do
  alias FeedbackCsv.Repo
  alias FeedbackCsv.Reviews.Review
  alias FeedbackCsv.Reviews.Author

  # Список всех отзывов в базе
  def list_review do
    Repo.all(Review) |> Repo.preload(:author)
  end

  # Загружает данные из .csv файла в БД
  def csv_to_db(filename) do
    filename
    |> load_csv
    |> to_db
  end

  # Читает и парсит .csv файл
  defp load_csv(filename) do
    filename
    |> read
    |> parse
  end

  # Считывает и парсит .csv файл 
  defp read(filename) do
    filename
    |> Path.expand()
    |> File.stream!()
    |> CSV.decode(headers: true, strip_fields: true)
  end

  # Получаем список мапов
  defp parse(data) do
    data
    |> Enum.take(Enum.count(data))
    |> Enum.map(fn {status, built} ->
      case status do
        :ok -> built
        _ -> nil
      end
    end)
    |> Enum.filter(&(&1 != nil))
  end

  # Готовим данные для загрузки в БД
  defp to_db(data) do
    try do
      Enum.map(data, &get_author_and_review/1)
      :ok
    rescue
      e in FunctionClauseError -> :error
    end
  end

  # Получаем структуры Отзыва и Автора
  defp get_author_and_review(map) do
    author_map = get_author(map)
    author_changeset = Author.changeset(%Author{}, author_map)
    review_map = get_review(map)
    author = Repo.insert(author_changeset)
    author_id = Kernel.elem(author, 1).id
    review_map = Map.merge(review_map, %{author_id: author_id})
    review_changeset = Review.changeset(%Review{}, review_map)
    Repo.insert(review_changeset)
  end

  # Получаем поля Отзыва
  defp get_review(map) do
    city = get_city(map)
    body = get_body(map)
    %{body: body, city: city}
  end

  # Получаем город Отзыва
  defp get_city(map) do
    data = map["Город"] || map["город"]
    String.trim(data)
  end

  # Получаем текст Отзыва
  defp get_body(map) do
    data = map["Текст"] || map["текст"]
    String.trim(data)
  end

  # Получаем поля Автора
  defp get_author(map) do
    name = get_name(map)
    sex = get_sex(map)
    %{name: name, sex: sex}
  end

  # Получаем имя Автора
  defp get_name(map) do
    data = map["Имя"] || map["имя"]
    String.trim(data)
  end

  # Получаем пол Автора
  defp get_sex(map) do
    data = map["Пол"] || map["пол"]
    String.trim(data)
  end
end
