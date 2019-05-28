defmodule FeedbackCsv.Emotions do
  @url "https://apis.paralleldots.com/v4/emotion"
  @api_key "PTEazLkKberIZlwBBBykxww77Bn9z6dxUMJAJL7AOeQ"

  def get_emotions(text) do
    body = {:form, [{:api_key, @api_key}, {:text, text}]}

    response =
      @url
      |> HTTPoison.post(body)
      |> Kernel.elem(1)

    body =
      response.body
      |> Jason.decode()
      |> Kernel.elem(1)

    get_emotion(body["emotion"])
  end

  defp get_emotion(emotions) do
    try do
      emotions
      |> Enum.reduce({"", 0}, fn elem, acc ->
        if Kernel.elem(elem, 1) > Kernel.elem(acc, 1) do
          elem
        else
          acc
        end
      end)
      |> Kernel.elem(0)
    rescue
      _ in _ -> nil
    end
  end
end
