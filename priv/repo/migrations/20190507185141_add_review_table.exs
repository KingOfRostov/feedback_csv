defmodule FeedbackCsv.Repo.Migrations.AddReviewTable do
  use Ecto.Migration

  def change do
    create table("review") do
      add :body, :text
      add :city, :string
      add :author_id, references(:authors)

      timestamps()
    end
  end
end
