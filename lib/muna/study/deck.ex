defmodule Muna.Study.Deck do
  use Ecto.Schema
  alias Muna.Study.Card
  import Ecto.Changeset

  schema "decks" do
    field(:name, :string)
    has_many(:cards, Card)

    timestamps()
  end

  @doc false
  def changeset(deck, attrs) do
    deck
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
