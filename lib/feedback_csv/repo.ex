defmodule FeedbackCsv.Repo do
  use Ecto.Repo,
    otp_app: :feedback_csv,
    adapter: Ecto.Adapters.Postgres
end
