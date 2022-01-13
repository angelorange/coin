defmodule Coin.Exchange.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :final_coin, :string
    field :final_value, :integer
    field :first_coin, :string
    field :first_value, :integer
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:first_coin, :first_value, :final_value, :final_coin])
    |> validate_required([:first_coin, :first_value, :final_value, :final_coin])
  end
end
