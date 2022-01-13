defmodule Coin.ExchangeTest do
  use Coin.DataCase

  alias Coin.Exchange

  import Coin.Factory

  describe "transactions" do
    alias Coin.Exchange.Transaction

    test "list_transactions/0 returns all transactions" do
      transaction = insert(:transaction)
      assert [subject] = Exchange.list_transactions()
      assert subject.id == transaction.id
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = insert(:transaction)
      assert Exchange.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      user = insert(:user)
      expected = params_for(:transaction, first_coin: "EUR", final_coin: "JPY", first_value: 10, final_value: 100, user_id: user.id)

      assert {:ok, %Transaction{} = transaction} = Exchange.create_transaction(expected)
      assert transaction.first_value == expected.first_value
      assert transaction.final_value == expected.final_value
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      params =
        params_for(:transaction, %{
          first_coin: nil,
          final_coin: nil,
          first_value: nil,
          final_value: nil
        })

      assert {:error, %Ecto.Changeset{}} = Exchange.create_transaction(params)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      user = insert(:user)
      transaction = insert(:transaction, %{user_id: user.id})
      updated = %{final_coin: "USD", final_value: 87, first_coin: "JPY", first_value: 100}

      assert {:ok, %Transaction{} = transaction} = Exchange.update_transaction(transaction, updated)
      assert transaction.final_coin == updated.final_coin
      assert transaction.final_value == updated.final_value
      assert transaction.first_coin == updated.first_coin
      assert transaction.first_value == updated.first_value
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = insert(:transaction)
      params = %{
        first_coin: nil,
        final_coin: nil,
        first_value: nil,
        final_value: nil
      }

      assert {:error, %Ecto.Changeset{}} = Exchange.update_transaction(transaction, params)
      assert transaction == Exchange.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = insert(:transaction)
      assert {:ok, %Transaction{}} = Exchange.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Exchange.get_transaction!(transaction.id) end
    end
  end
end
