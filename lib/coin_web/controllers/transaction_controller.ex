defmodule CoinWeb.TransactionController do
  use CoinWeb, :controller

  alias Coin.Exchange
  alias Coin.Exchange.Transaction

  action_fallback CoinWeb.FallbackController

  def index(conn, _params) do
    transactions = Exchange.list_transactions()
    render(conn, "index.json", transactions: transactions)
  end

  def create(conn, %{"transaction" => transaction_params}) do
    with {:ok, %Transaction{} = transaction} <- Exchange.create_transaction(transaction_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.transaction_path(conn, :show, transaction))
      |> render("show.json", transaction: transaction)
    end
  end

  def show(conn, %{"id" => id}) do
    transaction = Exchange.get_transaction!(id)
    render(conn, "show.json", transaction: transaction)
  end

  def update(conn, %{"id" => id, "transaction" => transaction_params}) do
    transaction = Exchange.get_transaction!(id)

    with {:ok, %Transaction{} = transaction} <- Exchange.update_transaction(transaction, transaction_params) do
      render(conn, "show.json", transaction: transaction)
    end
  end

  def delete(conn, %{"id" => id}) do
    transaction = Exchange.get_transaction!(id)

    with {:ok, %Transaction{}} <- Exchange.delete_transaction(transaction) do
      send_resp(conn, :no_content, "")
    end
  end
end
