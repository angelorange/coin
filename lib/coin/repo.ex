defmodule Coin.Repo do
  use Ecto.Repo,
    otp_app: :coin,
    adapter: Ecto.Adapters.Postgres
end
