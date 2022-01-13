defmodule CoinWeb.TransactionView do
  use CoinWeb, :view
  alias CoinWeb.TransactionView

  def render("index.json", %{transactions: transactions}) do
    %{data: render_many(transactions, TransactionView, "transaction.json")}
  end

  def render("show.json", %{transaction: transaction}) do
    %{data: render_one(transaction, TransactionView, "transaction.json")}
  end

  def render("transaction.json", %{transaction: transaction}) do
    %{
      id: transaction.id,
      first_coin: transaction.first_coin,
      first_value: transaction.first_value,
      final_value: transaction.final_value,
      final_coin: transaction.final_coin
    }
  end
end
