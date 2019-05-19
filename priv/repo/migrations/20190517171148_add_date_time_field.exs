defmodule FeedbackCsv.Repo.Migrations.RemoveDateTimeField do
  use Ecto.Migration

  def change do
    alter table("review") do
      add :date_time, :utc_datetime
    end
  end
end
