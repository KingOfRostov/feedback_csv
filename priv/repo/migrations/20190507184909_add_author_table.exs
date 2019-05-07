defmodule FeedbackCsv.Repo.Migrations.AddAuthorTable do
  use Ecto.Migration

  def change do
    create table("authors") do
      add :name, :string
      add :sex, :string
    end
  end
end
