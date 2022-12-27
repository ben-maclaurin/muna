defmodule Muna.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :front, :string
      add :back, :string
      add :deck_id, references(:decks)

      timestamps()
    end
  end
end
