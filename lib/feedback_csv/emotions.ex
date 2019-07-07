defmodule FeedbackCsv.Emotions do
  @url "https://apis.paralleldots.com/v4/emotion"
  @api_key "PTEazLkKberIZlwBBBykxww77Bn9z6dxUMJAJL7AOeQ"

  # Форматирует эмоциональный окрас отзыва из БД
  def format_emotion(emotion) do
    case emotion do
      nil -> "UNKNOWN"
      _ -> String.upcase(emotion)
    end
  end

  def get_emotions(text) do
    get_emotions_by(text, Mix.env())
  end

  defp get_emotions_by(_text, :test) do
    # ответ в формате, как возвращает сервис
    body = %{
      "emotion" => %{
        "Angry" => 0.2389363461,
        "Bored" => 0.117261253,
        "Excited" => 0.046245546,
        "Fear" => 0.0551760715,
        "Happy" => 0.1886819022,
        "Sad" => 0.1553198726
      }
    }

    get_emotion(body["emotion"])
  end

  defp get_emotions_by(text, env) when env in [:dev, :prod, :staging] do
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

  # Выбирает наиболее вероятную эмоцию по наибольшему значению
  # Например: %{"Angry" => 0.2389363461, "Bored" => 0.117261253} будет Angry
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
