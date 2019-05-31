defmodule FeedbackCsvWeb.ExcelWriterTest do
  use FeedbackCsv.DataCase
  alias FeedbackCsv.ExcelWriter

  @valid_data %{
    "FEMALE" => [
      %FeedbackCsv.Reviews.Review{
        author: %FeedbackCsv.Reviews.Author{
          id: 223,
          name: "Jane",
          sex: "Female"
        },
        author_id: 223,
        body:
          "Conflict in your company, is definitely going to be the next big thing, I can see it.",
        city: "Chikago",
        emotion: "Fear",
        id: 223,
        inserted_at: ~N[2019-05-31 13:46:27],
        updated_at: ~N[2019-05-31 13:46:27]
      }
    ]
  }

  @invalid_data ["FEMALE", "Jane", "Cool!"]

  test "gen_excel_report/2 success" do
    {:ok, time} = DateTime.now("Etc/UTC")
    # Генерируем имя для файла
    formated_time = String.replace(to_string(time), " ", "_")
    filename = "./media/report_#{formated_time}.xls"

    ExcelWriter.gen_excel_report(@valid_data, filename)

    assert File.exists?(filename)

    File.rm(filename)
  end

  test "gen_excel_report/2 fail" do
    {:ok, time} = DateTime.now("Etc/UTC")
    # Генерируем имя для файла
    formated_time = String.replace(to_string(time), " ", "_")
    filename = "./media/report_#{formated_time}.xls"

    _func_response = ExcelWriter.gen_excel_report(@invalid_data, filename)

    assert func_response = "Invalid data for gen_excel_report/2"

    refute File.exists?(filename)
  end
end
