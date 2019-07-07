defmodule FeedbackCsv.Reviews do
  alias FeedbackCsv.CsvLoader
  alias FeedbackCsv.Reviews.ReviewQueries
  alias FeedbackCsv.Emotions
  alias FeedbackCsv.ExcelWriter

  # Гененирует Эксель отчет
  def gen_excel_report(map, filename) do
    files = File.ls("media") |> Kernel.elem(1)
    Enum.map(files, &check_to_delete/1)
    ExcelWriter.gen_excel_report(map, filename)
  end

  # Генерирует имя файла
  def generate_filename(extension), do: CsvLoader.generate_filename(extension)

  def get_params(reviews, sort_param) do
    case sort_param do
      "---Критерии классификации---" ->
        Enum.group_by(reviews, &String.upcase(&1.author.sex))

      "Пол автора" ->
        Enum.group_by(reviews, &String.upcase(&1.author.sex))

      "Город" ->
        Enum.group_by(reviews, &String.upcase(&1.city))

      "Месяц, когда был получен отзыв" ->
        Enum.group_by(reviews, &get_month(&1.date_time.month))

      "Время суток, когда был получен отзыв" ->
        Enum.group_by(reviews, &get_time(&1.date_time.hour))

      "Эмоциональный окрас пользователя" ->
        Enum.group_by(reviews, &Emotions.format_emotion(&1.emotion))
    end
  end

  # Удаляет все вчерашние файлы в /media
  def check_to_delete(filename) do
    stat = File.stat("media/#{filename}") |> Kernel.elem(1)
    creation_day = Kernel.elem(stat.atime, 0) |> Kernel.elem(2)
    today = Date.utc_today().day

    cond do
      today == 1 and creation_day != 1 ->
        File.rm("media/#{filename}")

      today > creation_day ->
        File.rm("media/#{filename}")

      true ->
        nil
    end
  end

  def list_review(), do: ReviewQueries.list_review()

  # Получает эмоциональный окрас отзыва
  def get_emotion(list_text), do: Emotions.get_emotions(list_text)

  # Загружает данные из .csv файла в БД
  def load_from_csv(filename), do: CsvLoader.load_from_csv(filename)

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
