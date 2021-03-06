defmodule Coin.Factory do
  use ExMachina.Ecto, repo: Coin.Repo

  use Coin.UserFactory
  use Coin.TransactionFactory
end
