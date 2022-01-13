defmodule CoinWeb.TransactionControllerTest do
  use CoinWeb.ConnCase

  import Coin.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all transactions", %{conn: conn} do
      conn = get(conn, Routes.transaction_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create transaction" do
    test "renders transaction when data is valid", %{conn: conn} do
      params = params_for(:transaction)

      conn = post(conn, Routes.transaction_path(conn, :create), transaction: params)

      assert expected = json_response(conn, 201)["data"]
      assert expected["first_coin"] == params.first_coin
    end

    test "renders errors when data is invalid", %{conn: conn} do
      params = params_for(:transaction, %{
        first_coin: nil,
        final_coin: nil,
        first_value: nil,
        final_value: nil
      })
      conn = post(conn, Routes.transaction_path(conn, :create), transaction: params)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update transaction" do
    setup [:create_transaction]

    test "renders transaction when data is valid", %{conn: conn, transaction: transaction} do
      params = %{
        first_coin: transaction.first_coin,
        final_coin: transaction.final_coin,
        first_value: transaction.first_value,
        final_value: transaction.final_value
      }

      conn = put(conn, Routes.transaction_path(conn, :update, transaction), transaction: params)
      assert expected = json_response(conn, 200)["data"]
      assert expected["first_coin"] == params.first_coin
    end

    test "renders errors when data is invalid", %{conn: conn, transaction: transaction} do
      params = %{
        first_coin: nil,
        final_coin: nil,
        first_value: nil,
        final_value: nil
      }

      conn = put(conn, Routes.transaction_path(conn, :update, transaction), transaction: params)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete transaction" do
    setup [:create_transaction]

    test "deletes chosen transaction", %{conn: conn, transaction: transaction} do
      conn = delete(conn, Routes.transaction_path(conn, :delete, transaction))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.transaction_path(conn, :show, transaction))
      end
    end
  end

  defp create_transaction(_) do
    transaction = insert(:transaction)
    %{transaction: transaction}
  end
end
