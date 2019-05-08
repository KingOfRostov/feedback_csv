defmodule FeedbackCsvWeb.ReviewController do
  use FeedbackCsvWeb, :controller

  alias FeedbackCsv.Reviews.Review

  def index(conn, _params) do
    reviews = FeedbackCsv.Reviews.list_review()
    changeset = Review.changeset(%Review{}, %{})
    render(conn, "index.html", %{reviews: reviews, changeset: changeset})
  end

  # Если выбран какой-либо файл
  def create(conn, %{"review" => review_params}) do
    reviews = FeedbackCsv.Reviews.list_review()
    changeset = Review.changeset(%Review{}, %{})

    upload = review_params["csv"]
    extension = Path.extname(upload.filename)

    # Если загружен .csv файл - добавляем в ./media, иначе не добавляем 
    if(extension == ".csv") do
      {:ok, time} = DateTime.now("Etc/UTC")
      formated_time = String.replace(to_string(time), " ", "_")
      File.cp(upload.path, "./media/#{formated_time}#{extension}")

      put_flash(conn, :info, "Данные успешно обработаны")
      |> render("index.html", %{reviews: reviews, changeset: changeset})
    else
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
