defmodule FeedbackCsv.Reviews.Review do
  use Ecto.Schema
  import Ecto.Changeset
  alias FeedbackCsv.Reviews.Author
  alias FeedbackCsv.Reviews.Review

  @required [:body, :city, :date_time]

  schema "review" do
    field :body, :string
    field :city, :string
    field :date_time, :utc_datetime

    belongs_to :author, Author

    timestamps()
  end

  def changeset(%Review{} = review, attrs) do
    review
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> cast_assoc(:author, required: true)
  end
end
