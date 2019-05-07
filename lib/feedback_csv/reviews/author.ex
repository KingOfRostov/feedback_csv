defmodule FeedbackCsv.Reviews.Author do
  use Ecto.Schema
  import Ecto.Changeset
  alias FeedbackCsv.Reviews.Author
  alias FeedbackCsv.Reviews.Review

  schema "authors" do
    field :name, :string
    field :sex, :string

    has_many :reviews, Review
  end

  def changeset(%Author{} = author, attrs) do
    author
    |> cast(attrs, [:name, :sex])
    |> validate_required([:name, :sex])
  end
end
