defmodule FeedbackCsv.CsvLoader do
  alias FeedbackCsv.Emotions
  alias FeedbackCsv.Reviews.ReviewQueries

  # Загружает данные из .csv файла в БД
  def load_from_csv(filename) do
    case prepare_csv_to_db(filename) do
      {:ok, data} ->
        ReviewQueries.csv_to_db(data)
        :ok

      :error ->
        :error
    end
  end

  # Готовит данные из .csv файла для загрузки в БД
  def prepare_csv_to_db(filename) do
    filename
    |> load_csv
    |> prepare_to_db
  end

  # Генерирует имя файла
  def generate_filename(extension) do
    {:ok, time} = DateTime.now("Etc/UTC")
    # Генерируем имя для файла
    formated_time = String.replace(to_string(time), " ", "_")
    "./media/#{formated_time}#{extension}"
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
    |> CSV.decode(headers: true, strip_fields: true, separator: ?;)
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
  defp prepare_to_db(data) do
    try do
      {:ok, Enum.map(data, &get_author_and_review/1)}
    rescue
      _ in FunctionClauseError -> :error
    end
  end

  # Получаем структуры Отзыва и Автора
  defp get_author_and_review(map) do
    author_map = get_author(map)
    review_map = get_review(map)
    %{author: author_map, review: review_map}
  end

  # Получаем поля Отзыва
  defp get_review(map) do
    city = get_city(map)
    body = get_body(map)
    date_time = get_date_time(map)
    emotion = Emotions.get_emotions(body)

    %{body: body, city: city, date_time: date_time, emotion: emotion}
  end

  # Получаем город Отзыва
  defp get_city(map) do
    data = map["Город"] || map["город"]
    String.trim(data)
  end

  # Получаем дату Отзыва
  defp get_date_time(map) do
    data = map["Дата"] || map["дата"]

    data
    |> String.trim()
    |> String.to_integer()
    |> DateTime.from_unix()
    |> Kernel.elem(1)
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
