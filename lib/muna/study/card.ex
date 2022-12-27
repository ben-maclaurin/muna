defmodule Muna.Study.Card do
  use Ecto.Schema
  alias Muna.Study.Deck
  import Ecto.Changeset

  schema "cards" do
    field(:front, :string)
    field(:back, :string)
    belongs_to(:deck, Deck)

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:front, :back, :deck_id])
    |> validate_required([:front, :back, :deck_id])
  end
end
