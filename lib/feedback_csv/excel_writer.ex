defmodule FeedbackCsv.ExcelWriter do
  alias Elixlsx.Workbook
  alias Elixlsx.Sheet

  # Генерирует Эксель отчет
  def gen_excel_report(map, filename) do
    try do
      map
      |> gen_workbook()
      |> Elixlsx.write_to(filename)

      {:ok, filename}
    rescue
      _ in _ -> :error
    end
  end

  # Генерирует Эксель файл.
  defp gen_workbook(map) do
    sheets = Enum.reduce(map, [], fn reviews, acc -> acc ++ [gen_sheet(reviews)] end)

    %Workbook{sheets: sheets}
  end

  # Генерирует страницу Эксель документа.
  defp gen_sheet(reviews) do
    name = Kernel.elem(reviews, 0)

    rows =
      Enum.reduce(Kernel.elem(reviews, 1), [], fn review, acc ->
        acc ++ [[review.author.name, review.body]]
      end)

    %Sheet{name: name, rows: rows}
  end
end
