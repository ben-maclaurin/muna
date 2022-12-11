defmodule Muna.StudyTest do
  use Muna.DataCase

  alias Muna.Study

  describe "decks" do
    alias Muna.Study.Deck

    import Muna.StudyFixtures

    @invalid_attrs %{name: nil}

    test "list_decks/0 returns all decks" do
      deck = deck_fixture()
      assert Study.list_decks() == [deck]
    end

    test "get_deck!/1 returns the deck with given id" do
      deck = deck_fixture()
      assert Study.get_deck!(deck.id) == deck
    end

    test "create_deck/1 with valid data creates a deck" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Deck{} = deck} = Study.create_deck(valid_attrs)
      assert deck.name == "some name"
    end

    test "create_deck/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Study.create_deck(@invalid_attrs)
    end

    test "update_deck/2 with valid data updates the deck" do
      deck = deck_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Deck{} = deck} = Study.update_deck(deck, update_attrs)
      assert deck.name == "some updated name"
    end

    test "update_deck/2 with invalid data returns error changeset" do
      deck = deck_fixture()
      assert {:error, %Ecto.Changeset{}} = Study.update_deck(deck, @invalid_attrs)
      assert deck == Study.get_deck!(deck.id)
    end

    test "delete_deck/1 deletes the deck" do
      deck = deck_fixture()
      assert {:ok, %Deck{}} = Study.delete_deck(deck)
      assert_raise Ecto.NoResultsError, fn -> Study.get_deck!(deck.id) end
    end

    test "change_deck/1 returns a deck changeset" do
      deck = deck_fixture()
      assert %Ecto.Changeset{} = Study.change_deck(deck)
    end
  end
end
