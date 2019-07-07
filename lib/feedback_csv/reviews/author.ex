defmodule FeedbackCsv.Reviews.Author do
  use Ecto.Schema
  import Ecto.Changeset
  alias FeedbackCsv.Reviews
  @required [:name, :sex]

  schema "authors" do
    field :name, :string
    field :sex, :string

    has_many :reviews, Reviews.Review
  end

  def changeset(%Reviews.Author{} = author, attrs) do
    author
    |> cast(attrs, @required)
    |> validate_required(@required)
  end
end
