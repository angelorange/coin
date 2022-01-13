defmodule Coin.AccountsTest do
  use Coin.DataCase, async: true

  alias Coin.Accounts

  import Coin.Factory

  describe "users" do
    alias Coin.Accounts.User

    test "list_users/0 returns all users" do
      user = insert(:user)
      assert [subject] = Accounts.list_users()
      assert subject.id == user.id
    end

    test "get_user!/1 returns the user with given id" do
      user = insert(:user)
      assert Accounts.get_user!(user.id) == user
    end

    test "get_user/1 returns the user with given id" do
      user = insert(:user)
      assert {:ok, ^user} = Accounts.get_user(user.id)
    end

    test "create_user/1 with valid data creates a user" do
      expected = params_for(:user, email: "gojou@gmail.com")

      assert {:ok, %User{} = user} = Accounts.create_user(expected)
      assert user.email == expected.email
      assert user.name == expected.name
    end

    test "create_user/1 with invalid data returns error changeset" do
      params =
        params_for(:user, %{
          email: nil,
          name: nil
        })

      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(params)
    end

    test "update_user/2 with valid data updates the user" do
      user = insert(:user)
      updated = %{email: "megumi@gmail.com", name: "megumi"}

      assert {:ok, %User{} = user} = Accounts.update_user(user, updated)
      assert user.email == updated.email
      assert user.name == updated.name
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = insert(:user)

      params = %{
        name: nil,
        email: nil
      }

      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, params)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = insert(:user)
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end
  end
end
