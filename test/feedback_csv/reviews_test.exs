defmodule FeedbackCsvWeb.ReviewsTest do
  use FeedbackCsv.DataCase

  alias FeedbackCsv.Repo
  alias FeedbackCsv.Reviews

  def create_author(attrs \\ %{}) do
    changeset = Reviews.Author.changeset(%Reviews.Author{}, attrs)
    {:ok, author} = Repo.insert(changeset)
    author
  end

  def create_review(attrs \\ %{}) do
    changeset = Reviews.Review.changeset(%Reviews.Review{}, attrs)
    {:ok, review} = Repo.insert(changeset)
    review = Repo.preload(review, :author)
  end

  test "list_review/0 returns all reviews" do
    author = create_author(%{name: "Steve", sex: "Male"})
    review = create_review(%{body: "Cool!", city: "New-York", author_id: author.id})
    assert Reviews.list_review() == [review]
  end
end
