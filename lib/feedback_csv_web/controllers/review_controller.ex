defmodule FeedbackCsvWeb.ReviewController do
  use FeedbackCsvWeb, :controller

  alias FeedbackCsv.Reviews.Review
  alias FeedbackCsv.Reviews

  def index(conn, _params) do
    reviews = FeedbackCsv.Reviews.list_review()
    changeset = Review.changeset(%Review{}, %{})
    render(conn, "index.html", %{reviews: reviews, changeset: changeset})
  end

  # Если выбран какой-либо файл
  def create(conn, %{"review" => review_params}) do
    upload = review_params["csv"]
    extension = Path.extname(upload.filename)

    # Если загружен .csv файл - добавляем в ./media, иначе не добавляем 
    if(extension == ".csv") do
      {:ok, time} = DateTime.now("Etc/UTC")
      # Генерируем имя для файла
      formated_time = String.replace(to_string(time), " ", "_")
      formated_name = "./media/#{formated_time}#{extension}"
      # Переносим файлы в папку ./media
      File.cp(upload.path, formated_name)

      # Загружаем данные из csv файла в БД, а затем удаляем файл
      status = Reviews.csv_to_db(formated_name)
      File.rm(formated_name)

      reviews = FeedbackCsv.Reviews.list_review()
      changeset = Review.changeset(%Review{}, %{})

      if status == :ok do
        put_flash(conn, :info, "Данные успешно загружены")
      else
        put_flash(conn, :error, "Некорректная структура csv файла")
      end
      |> render("index.html", %{reviews: reviews, changeset: changeset})
    else
      reviews = FeedbackCsv.Reviews.list_review()
      changeset = Review.changeset(%Review{}, %{})

      put_flash(conn, :error, "Принимаются только .csv файлы")
      |> render("index.html", %{reviews: reviews, changeset: changeset})
    end
  end

  # Если не выбран файл
  def create(conn, _params) do
    reviews = FeedbackCsv.Reviews.list_review()
    changeset = Review.changeset(%Review{}, %{})

    put_flash(conn, :error, "Выберите файл")
    |> render("index.html", %{reviews: reviews, changeset: changeset})
  end
end
