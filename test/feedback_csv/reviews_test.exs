defmodule FeedbackCsvWeb.ReviewsTest do
  use FeedbackCsv.DataCase

  alias FeedbackCsv.Repo
  alias FeedbackCsv.Reviews

  def create_review(attrs \\ %{}) do
    changeset = Reviews.Review.changeset(%Reviews.Review{}, attrs)
    {:ok, review} = Repo.insert(changeset)
    Repo.preload(review, :author)
  end

  test "list_review/0 returns all reviews" do
    author = %{name: "Steve", sex: "Male"}
    review = create_review(%{body: "Cool!", city: "New-York", author: author})

    assert Reviews.list_review() == [review]
  end
end
