defmodule FeedbackCsvWeb.CsvLoaderTest do
  use FeedbackCsv.DataCase
  alias FeedbackCsv.CsvLoader

  @valid_data %{
    author: %{name: "Steve", sex: "male"},
    review: %{
      date_time: DateTime.from_unix!(1486035766),
      body:
        "My girlfriend is always stealing my t-shirts and sweaters but if I take one of her dresses suddenly we need to talk.",
      city: "New-York"
    }
  }

  test "prepare_csv_to_db/1" do
    filename = "test/tmp/data.csv"
    {status, data} = CsvLoader.prepare_csv_to_db(filename)
    
    assert status == :ok
    assert Enum.find(data, &(&1 == @valid_data)) != nil
  end
end
