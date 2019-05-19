defmodule FeedbackCsvWeb.ReviewsTest do
  use FeedbackCsv.DataCase

  alias FeedbackCsv.Reviews
  alias FeedbackCsv.Reviews.Review

  @valid_attrs %{
    body: "Cool!",
    city: "New-York",
    date_time:
      1_494_719_407
      |> DateTime.from_unix()
      |> Kernel.elem(1),
    author: %{name: "Steve", sex: "Male"}
  }
  @invalid_attrs %{
    body: "Cool!",
    city: "New-York",
    date_time:
      1_494_719_407
      |> DateTime.from_unix()
      |> Kernel.elem(1),
    author: %{name: "Steve"}
  }

  test "change_review/2 returns can't be blank" do
    changeset = Reviews.change_review(%Review{}, @invalid_attrs)

    assert %{author: %{sex: ["can't be blank"]}} ==
             errors_on(changeset)
  end

  test "change_review/2 returns valid changeset" do
    changeset = Reviews.change_review(%Review{}, @valid_attrs)
    assert changeset.valid?
  end

  test "change_review/0 returns invalid changeset" do
    refute Reviews.change_review().valid?
  end

  test "create_review/1 with valid data creates a review" do
    assert {:ok, review} = Reviews.create_review(@valid_attrs)
    assert review.date_time == DateTime.from_unix!(1_494_719_407)
    assert review.body == "Cool!"
    assert review.city == "New-York"
    assert review.author.name == "Steve"
    assert review.author.sex == "Male"
  end

  test "create_review/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Reviews.create_review(@invalid_attrs)
  end

  test "list_review/0 returns empty list" do
    assert Reviews.list_review() == []
  end

  test "list_review/0 returns all reviews when" do
    {:ok, review} = Reviews.create_review(@valid_attrs)
    assert Reviews.list_review() == [review]
  end
end
