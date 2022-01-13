defmodule CoinWeb.Router do
  use CoinWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CoinWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
    resources "/transactions", TransactionController, except: [:new, :edit]
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: CoinWeb.Telemetry
    end
  end
end
