defmodule Muna.Study.Card do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cards" do
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
