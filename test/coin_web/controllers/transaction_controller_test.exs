defmodule CoinWeb.TransactionControllerTest do
  use CoinWeb.ConnCase

  import Coin.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all transactions by a user", %{conn: conn} do
      user = insert(:user)
      transaction = insert(:transaction, %{user: user})
      insert(:transaction)

      params = %{user_id: user.id}

      conn = get(conn, Routes.transaction_path(conn, :index, params))
      assert [expected] = json_response(conn, 200)["data"]
      assert expected["user_id"] == params.user_id
      assert expected["id"] == transaction.id
    end
  end

  describe "create transaction" do
    setup do
      body = %{
        "success" => true,
        "timestamp" => 1_642_090_443,
        "base" => "EUR",
        "rates" => %{"BRL" => 6.319786, "EUR" => 1, "JPY" => 130.752433, "USD" => 1.146217}
      }

      Tesla.Mock.mock(fn
        %{method: :get} ->
          %Tesla.Env{status: 200, body: body}
      end)

      :ok
    end

    test "renders transaction when transfer USD to BRL", %{conn: conn} do
      user = insert(:user)

      params = %{
        user_id: user.id,
        first_coin: "USD",
        first_value: 6000,
        final_coin: "BRL"
      }

      conn = post(conn, Routes.transaction_path(conn, :create), transaction: params)

      assert expected = json_response(conn, 201)["data"]
      assert expected["first_coin"] == params.first_coin
      assert expected["final_coin"] == params.final_coin
      assert expected["first_value"] == "$60.00"
      assert expected["final_value"] == "R$330.82"
    end

    test "renders transaction when transfer BRL to USD", %{conn: conn} do
      user = insert(:user)

      params = %{
        user_id: user.id,
        first_coin: "BRL",
        first_value: 33000,
        final_coin: "USD"
      }

      conn = post(conn, Routes.transaction_path(conn, :create), transaction: params)

      assert expected = json_response(conn, 201)["data"]
      assert expected["first_coin"] == params.first_coin
      assert expected["final_coin"] == params.final_coin
      assert expected["first_value"] == "R$330.00"
      assert expected["final_value"] == "$59.85"
    end

    test "renders transaction when transfer USD to JPY", %{conn: conn} do
      user = insert(:user)

      params = %{
        user_id: user.id,
        first_coin: "USD",
        first_value: 100_000,
        final_coin: "JPY"
      }

      conn = post(conn, Routes.transaction_path(conn, :create), transaction: params)

      assert expected = json_response(conn, 201)["data"]
      assert expected["first_coin"] == params.first_coin
      assert expected["final_coin"] == params.final_coin
      assert expected["first_value"] == "$1,000.00"
      assert expected["final_value"] == "??11,407,302"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      params =
        params_for(:transaction, %{
          first_coin: "BTC",
          final_coin: "SOL",
          first_value: 10,
          final_value: 0
        })

      conn = post(conn, Routes.transaction_path(conn, :create), transaction: params)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when third api fails", %{conn: conn} do
      Tesla.Mock.mock(fn
        %{method: :get} ->
          {:error, :socket_closed_remotely}
      end)

      user = insert(:user)

      params = %{
        user_id: user.id,
        first_coin: "USD",
        first_value: 6000,
        final_coin: "BRL"
      }

      conn = post(conn, Routes.transaction_path(conn, :create), transaction: params)
      assert json_response(conn, 503)
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
