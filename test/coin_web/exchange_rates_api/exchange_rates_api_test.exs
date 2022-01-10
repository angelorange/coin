defmodule CoinWebExchangeRatesApiTest do
  use Coin.DataCase
  alias CoinWebExchangeRatesApi, as: Api
  import ExUnit.CaptureLog

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

      assert log =
               capture_log(fn ->
                 assert {:error, :api_error} = Api.response()
               end)

      assert log =~ "Error when try to retrieve response"
    end
  end

  describe "rate/0" do
    test "successfully get the data" do
      Tesla.Mock.mock(fn
        %{method: :get} ->
          %Tesla.Env{status: 200, body: %{"rates" => %{"EUR" => 1}, "success" => true}}
      end)

      res = Api.rate()

      assert {:ok, %{"EUR" => 1}} = res
    end

    test "fails to get the data" do
      Tesla.Mock.mock(fn
        %{method: :get} ->
          {:error, :socket_closed_remotely}
      end)

      assert log =
               capture_log(fn ->
                 assert {:error, :api_error} = Api.rate()
               end)

      assert log =~ "Error when try to get rate from the body"
    end
  end

  describe "timestamp/0" do
    test "successfully get the data" do
      Tesla.Mock.mock(fn
        %{method: :get} ->
          %Tesla.Env{status: 200, body: %{"success" => true, "timestamp" => 1_641_846_244}}
      end)

      res = Api.timestamp()

      assert res = {:ok, ~U[2022-01-10 20:24:04Z]}
    end

    test "fails to get the data" do
      Tesla.Mock.mock(fn
        %{method: :get} ->
          {:error, :socket_closed_remotely}
      end)

      assert log =
               capture_log(fn ->
                 assert {:error, :api_error} = Api.timestamp()
               end)

      assert log =~ "Error when try to get timestamp from body"
    end
  end
end
