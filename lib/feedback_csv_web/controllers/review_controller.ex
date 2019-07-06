defmodule FeedbackCsvWeb.ReviewController do
  use FeedbackCsvWeb, :controller

  alias FeedbackCsv.Reviews

  def index(conn, _params) do
    reviews = Reviews.list_review()
    changeset = Reviews.change_review()
    render(conn, "index.html", %{reviews: reviews, changeset: changeset})
  end

  # Если выбран какой-либо файл
  def create(conn, %{"review" => review_params}) do
    upload = review_params["csv"]
    extension = Path.extname(upload.filename)

    changeset = Reviews.change_review()
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
      case Reviews.load_from_csv(formated_name) do
        :ok ->
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
    changeset = Reviews.change_review()

    put_flash(conn, :error, "Выберите файл")
    |> render("index.html", %{reviews: reviews, changeset: changeset})
  end

  def show(conn, %{"review" => review_params}) do
    sort_param = review_params["sort_param"]
    show_form = review_params["show_form"]
    reviews = Reviews.list_review()
    changeset = Reviews.change_review()

    params =
      case sort_param do
        "---Критерии классификации---" ->
          Enum.group_by(reviews, &String.upcase(&1.author.sex))

        "Пол автора" ->
          Enum.group_by(reviews, &String.upcase(&1.author.sex))

        "Город" ->
          Enum.group_by(reviews, &String.upcase(&1.city))

        "Месяц, когда был получен отзыв" ->
          Enum.group_by(reviews, &Reviews.get_month(&1.date_time.month))

        "Время суток, когда был получен отзыв" ->
          Enum.group_by(reviews, &Reviews.get_time(&1.date_time.hour))

        "Эмоциональный окрас пользователя" ->
          Enum.group_by(reviews, &Reviews.format_emotion(&1.emotion))
      end

    if show_form == "HTML-страница" or show_form == "---Форма отчета---" do
      render(conn, "show.html", %{reviews: reviews, params: params})
    else
      {:ok, time} = DateTime.now("Etc/UTC")
      # Генерируем имя для файла
      formated_time = String.replace(to_string(time), " ", "_")
      filename = "./media/report_#{formated_time}.xls"

      case Reviews.gen_excel_report(params, filename) do
        {:ok, filename} ->
          conn
          |> send_download({:file, filename})
          |> render("index.html", %{reviews: reviews, changeset: changeset})

        :error ->
          render(conn, "index.html", %{reviews: reviews, changeset: changeset})
      end
    end
  end
end
