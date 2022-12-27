defmodule Muna.Study.Card do
  use Ecto.Schema
  alias Muna.Study.Deck
  import Ecto.Changeset

  schema "cards" do
    field(:title, :string)
    belongs_to(:decks, Deck)

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
