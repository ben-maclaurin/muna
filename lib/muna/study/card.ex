defmodule Muna.Study.Card do
  use Ecto.Schema
  alias Muna.Study.Deck
  import Ecto.Changeset

  schema "cards" do
    field(:title, :string)
    belongs_to(:deck, Deck)

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:title, :deck_id])
    |> validate_required([:title, :deck_id])
  end
end
