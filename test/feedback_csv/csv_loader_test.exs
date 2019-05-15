defmodule FeedbackCsvWeb.CsvLoaderTest do
  use FeedbackCsv.DataCase
  alias FeedbackCsv.CsvLoader

  def create_test_csv() do
    csv =
      CSV.encode([
        ~w(Имя Пол Город Текст Дата),
        ["Олег", "Мужской", "Ростов-на-Дону", "Мне очень понравилось", "07.09.1998"]
      ])
      |> Enum.take(2)

    File.write("media/t.csv", csv)
  end

  test "prepare_csv_to_db/1" do
    create_test_csv()
    filename = "media/t.csv"
    data = CsvLoader.prepare_csv_to_db(filename)
    File.rm(filename)

    assert data ==
             {:ok,
              [
                %{
                  author: %{name: "Олег", sex: "Мужской"},
                  review: %{
                    body: "Мне очень понравилось",
                    city: "Ростов-на-Дону"
                  }
                }
              ]}
  end
end
