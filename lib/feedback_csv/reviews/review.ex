defmodule FeedbackCsv.Reviews.Review do
  use Ecto.Schema
  import Ecto.Changeset
  alias FeedbackCsv.Reviews.Author
  alias FeedbackCsv.Reviews.Review

  @required [:body, :city, :date_time]
  @optional [:emotion]

  schema "review" do
    field :body, :string, null: false
    field :city, :string, null: false
    field :date_time, :utc_datetime, null: false
    field :emotion, :string

    belongs_to :author, Author

    timestamps()
  end

  def changeset(%Review{} = review, attrs) do
    review
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> cast_assoc(:author, required: true)
  end
end
