defmodule Coin.Repo.Migrations.AddTimestampToTransactions do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      add :timestamps, :utc_datetime
    end
  end
end
