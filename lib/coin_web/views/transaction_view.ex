defmodule CoinWeb.TransactionView do
  use CoinWeb, :view
  alias CoinWeb.TransactionView

  def render("index.json", %{transactions: transactions}) do
    %{data: render_many(transactions, TransactionView, "transaction.json")}
  end

  def render("show.json", %{transaction: transaction}) do
    %{data: render_one(transaction, TransactionView, "transaction.json")}
  end

  def render("transaction.json", %{transaction: t}) do
    %{
      id: t.id,
      first_coin: t.first_coin,
      first_value: to_string(t.first_value, t.first_coin),
      final_value: to_string(t.final_value, t.final_coin),
      final_coin: t.final_coin,
      timestamps: t.timestamps
    }
  end

  defp to_string(value, coin) do
    value |> Money.new(coin |> String.to_atom()) |> Money.to_string()
  end
end
