defmodule CoinWebExchangeRatesApiTest do
	use Coin.DataCase
	alias CoinWebExchangeRatesApi, as: Api

  setup do
    Tesla.Mock.mock(fn
      %{method: :get} ->
        %Tesla.Env{status: 200, body: "hello"}
    end)

    :ok
  end

  describe "response/0" do
    test "successfully get the data" do
      Tesla.Mock.mock(fn
        %{method: :get} ->
          %Tesla.Env{status: 200, body: %{"success" => true}}
      end)

      res = Api.response()

      assert {:ok, %{"success" => true}} = res
    end

    test "fails to get the data" do
      Tesla.Mock.mock(fn
        %{method: :get} ->
          {:error, :socket_closed_remotely}
      end)

      res = Api.response()

      assert {:error, :api_error} = res
    end
  end

  describe "rate/0" do
    test "successfully get the data" do
      Tesla.Mock.mock(fn
        %{method: :get} ->
          %Tesla.Env{status: 200, body: %{"rates" => %{"EUR" => 1},"success" => true}}
      end)

      res = Api.rate()

      assert {:ok, %{"EUR" => 1}} = res
    end

    test "fails to get the data" do
      Tesla.Mock.mock(fn
        %{method: :get} ->
          {:error, :socket_closed_remotely}
      end)

      res = Api.rate()

      assert {:error, :api_error} = res
    end
  end

  describe "timestamp/0" do
    test "successfully get the data" do
      Tesla.Mock.mock(fn
        %{method: :get} ->
          %Tesla.Env{status: 200, body: %{"success" => true, "timestamp" => 1641846244}}
      end)

      res = Api.timestamp

      assert res = {:ok, ~U[2022-01-10 20:24:04Z]}
    end

    test "fails to get the data" do
      Tesla.Mock.mock(fn
        %{method: :get} ->
          {:error, :socket_closed_remotely}
      end)

      res = Api.timestamp

      assert {:error, :api_error} = res
    end
  end
end
