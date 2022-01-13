defmodule CoinWeb.TransactionController do
  use CoinWeb, :controller

  alias Coin.Exchange
  alias Coin.Exchange.Transaction

  action_fallback CoinWeb.FallbackController

  def create(conn, %{"transaction" => transaction_params}) do
    with {:ok, params} <- Exchange.calc(transaction_params),
         {:ok, %Transaction{} = transaction} <- Exchange.create_transaction(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.transaction_path(conn, :show, transaction))
      |> render("show.json", transaction: transaction)
    end
  end

  def index(conn, params) do
    transactions = Exchange.list_transactions_by_user(params["user_id"])
    render(conn, "index.json", transactions: transactions)
  end

  def show(conn, %{"id" => id}) do
    transaction = Exchange.get_transaction!(id)
    render(conn, "show.json", transaction: transaction)
  end

  def delete(conn, %{"id" => id}) do
    transaction = Exchange.get_transaction!(id)

    with {:ok, %Transaction{}} <- Exchange.delete_transaction(transaction) do
      send_resp(conn, :no_content, "")
    end
  end
end
