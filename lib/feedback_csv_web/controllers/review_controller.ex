defmodule FeedbackCsvWeb.ReviewController do
  use FeedbackCsvWeb, :controller

  alias FeedbackCsv.Reviews.Review
  alias FeedbackCsv.Reviews
  alias FeedbackCsv.Repo

  import Ecto.Query, only: [from: 2]

  def index(conn, _params) do
    reviews = Reviews.list_review()
    changeset = Review.changeset(%Review{}, %{})
    render(conn, "index.html", %{reviews: reviews, changeset: changeset})
  end

  # Если выбран какой-либо файл
  def create(conn, %{"review" => review_params}) do
    upload = review_params["csv"]
    extension = Path.extname(upload.filename)

    changeset = Review.changeset(%Review{}, %{})
    reviews = Reviews.list_review()

    # Если загружен .csv файл - добавляем в ./media, иначе не добавляем 
    if(extension == ".csv") do
      {:ok, time} = DateTime.now("Etc/UTC")
      # Генерируем имя для файла
      formated_time = String.replace(to_string(time), " ", "_")
      formated_name = "./media/#{formated_time}#{extension}"
      # Переносим файлы в папку ./media
      File.cp(upload.path, formated_name)

      # Загружаем данные из csv файла в БД, а затем удаляем файл
      case Reviews.prepare_csv_to_db(formated_name) do
        {:ok, data} ->
          Reviews.csv_to_db(data)
          reviews = Reviews.list_review()

          put_flash(conn, :info, "Данные успешно загружены")
          |> render("index.html", %{reviews: reviews, changeset: changeset})

        :error ->
          put_flash(conn, :error, "Некорректная структура csv файла")
          |> render("index.html", %{reviews: reviews, changeset: changeset})
      end

      File.rm(formated_name)
    else
      put_flash(conn, :error, "Принимаются только .csv файлы")
      |> render("index.html", %{reviews: reviews, changeset: changeset})
    end
  end

  # Если не выбран файл
  def create(conn, _params) do
    reviews = Reviews.list_review()
    changeset = Review.changeset(%Review{}, %{})

    put_flash(conn, :error, "Выберите файл")
    |> render("index.html", %{reviews: reviews, changeset: changeset})
  end

  def show(conn, %{"review" => review_params}) do
    sort_param = review_params["sort_param"]
    reviews = Reviews.list_review()
    show_form = review_params["show_form"]

    query = Repo.all(from r in Review, where: r.city == "Ростов-на-Дону", select: r.body)

    if show_form == "HTML-страница" or show_form == "---Форма отчета---" do
      render(conn, "show.html", %{reviews: reviews, sort_param: sort_param, query: query})
    else
      render(conn, "excel.html")
    end
  end
end
