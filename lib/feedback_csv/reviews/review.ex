defmodule FeedbackCsv.Reviews.Review do
  use Ecto.Schema
  import Ecto.Changeset
  alias FeedbackCsv.Reviews.Author
  alias FeedbackCsv.Reviews.Review

  schema "review" do
    field :body, :string
    field :city, :string

    belongs_to :author, Author

    timestamps()
  end

  def changeset(%Review{} = review, attrs) do
    review
    |> cast(attrs, [:body, :city, :author_id])
    |> validate_required([:body, :city, :author_id])
  end
end