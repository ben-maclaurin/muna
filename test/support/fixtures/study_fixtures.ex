defmodule Muna.StudyFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Muna.Study` context.
  """

  @doc """
  Generate a deck.
  """
  def deck_fixture(attrs \\ %{}) do
    {:ok, deck} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Muna.Study.create_deck()

    deck
  end

  @doc """
  Generate a card.
  """
  def card_fixture(attrs \\ %{}) do
    {:ok, card} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> Muna.Study.create_card()

    card
  end
end
