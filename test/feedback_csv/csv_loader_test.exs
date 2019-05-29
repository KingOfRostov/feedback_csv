defmodule FeedbackCsvWeb.CsvLoaderTest do
  use FeedbackCsv.DataCase
  alias FeedbackCsv.CsvLoader

  @valid_data %{
    author: %{name: "Steve", sex: "male"},
    review: %{
      date_time:
        1_486_035_766
        |> DateTime.from_unix()
        |> Kernel.elem(1),
      body:
        "My girlfriend is always stealing my t-shirts and sweaters but if I take one of her dresses suddenly we need to talk.",
      city: "New-York",
      emotion: "Angry"
    }
  }

  test "prepare_csv_to_db/1" do
    filename = "test/tmp/data.csv"
    assert {:ok, data} = CsvLoader.prepare_csv_to_db(filename, :test)

    assert Enum.find(data, &(&1 == @valid_data)) != nil
  end
end
