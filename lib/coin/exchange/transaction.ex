defmodule Coin.Exchange.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :final_coin, :string
    field :final_value, :integer
    field :first_coin, :string
    field :first_value, :integer

    belongs_to(:user, Coin.Accounts.User)

    timestamps()
  end

  @required ~w(final_coin user_id first_coin first_value final_value)a
  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> validate_inclusion(:first_coin, ["BRL", "JPY", "EUR", "USD"])
    |> validate_inclusion(:final_coin, ["BRL", "JPY", "EUR", "USD"])
    |> validate_number(:first_value, greater_than: 0)
    |> validate_number(:final_value, greater_than: 0)
  end
end
