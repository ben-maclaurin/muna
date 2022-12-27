defmodule Muna.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :front, :string
      add :back, :string
      add :deck_id, references(:decks, on_delete: :delete_all)

      timestamps()
    end
  end
end
