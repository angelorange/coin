defmodule CoinWeb.UserControllerTest do
  use CoinWeb.ConnCase, async: true

  alias Coin.Accounts.User

  import Coin.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      params = params_for(:user)

      conn = post(conn, Routes.user_path(conn, :create), user: params)

      assert expected = json_response(conn, 201)["data"]
      assert expected["name"] == params.name
      assert expected["email"] == params.email
    end

    test "renders errors when data is invalid", %{conn: conn} do
      params = params_for(:user, %{
        email: nil,
        name: nil
      })
      conn = post(conn, Routes.user_path(conn, :create), user: params)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      params = %{
        name: user.name,
        email: user.email
      }

      conn = put(conn, Routes.user_path(conn, :update, user), user: params)
      assert expected = json_response(conn, 200)["data"]
      assert expected["name"] == params.name
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      params = %{
        name: nil,
        email: nil
      }
      conn = put(conn, Routes.user_path(conn, :update, user), user: params)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = insert(:user)
    %{user: user}
  end
end
