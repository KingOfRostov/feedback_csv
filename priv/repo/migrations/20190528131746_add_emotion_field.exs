defmodule FeedbackCsv.Repo.Migrations.AddEmotionField do
  use Ecto.Migration

  def change do
    alter table("review") do
      add :emotion, :string, null: true
    end
  end
end
