defmodule Coin.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :first_coin, :string
      add :first_value, :integer
      add :final_value, :integer
      add :final_coin, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:transactions, [:user_id])
  end
end
