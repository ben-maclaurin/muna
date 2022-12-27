defmodule Muna.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :title, :string
      add :decks_id, :integer

      timestamps()
    end
  end
end
