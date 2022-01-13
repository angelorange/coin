defmodule Coin.Exchange do
  @moduledoc """
  The Exchange context.
  """

  import Ecto.Query, warn: false

  alias Coin.Exchange.Transaction
  alias Coin.Repo
  alias CoinWeb.ExchangeRatesApi, as: Api

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions do
    Repo.all(Transaction)
  end

  @doc """
  List all transactions by a User.
  """
  @spec list_transactions_by_user(Integer.t() | String.t()) :: list()
  def list_transactions_by_user(user_id) do
    Transaction
    |> where([t], t.user_id == ^user_id)
    |> Repo.all()
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  def calc(%{"first_value" => _, "final_coin" => _, "first_coin" => _} = args) do
    {:ok, rate} = Api.rate()
    {:ok, timestamps} = Api.timestamp()

    value =
      args["first_value"]
      |> Kernel./(rate[args["first_coin"]] || 1)
      |> Kernel.*(rate[args["final_coin"]] || 1)
      |> round

    {:ok, Map.merge(args, %{"final_value" => value, "timestamps" => timestamps})}
  end

  def calc(_args), do: {:error, :invalid_args}
end
