defmodule CoinWeb.ExchangeRatesApi do
  use Tesla
  require Logger

  plug Tesla.Middleware.BaseUrl, "http://api.exchangeratesapi.io"
  plug Tesla.Middleware.Headers, [{"content-type", "application/json"}]
  plug Tesla.Middleware.JSON

  @key "2d7894e66abd33754b9bfeb455bdb4ea"

  @doc """
  Returns the body of the response from the ExchangeRates.
  If it any problem happens, it returns a error.
  """
  @spec response() :: {:ok, map()} | {:error, :api_error}
  def response do
    case get("/latest?access_key=#{@key}&symbols=USD,BRL,JPY,EUR") do
      {:ok, %Tesla.Env{status: 200, body: %{"success" => true}} = res} ->
        {:ok, res.body}

      error ->
        Logger.warn(
          "Error when try to retrieve response from exchange rates api, #{inspect(error)}"
        )

        {:error, :api_error}
    end
  end

  @doc """
  Returns the rates of the response.
  If it any problem happens, it returns a error.
  """
  @spec rate() :: {:ok, map()} | {:error, :api_error}
  def rate do
    case response() do
      {:ok, body} ->
        {:ok, body["rates"]}

      _ ->
        Logger.warn("Error when try to get rate from the body")
        {:error, :api_error}
    end
  end

  @doc """
  Returns the Datetime of the response.
  If it any problem happens, it returns a error.
  """
  @spec timestamp() :: {:ok, DateTime.t()} | {:error, :api_error}
  def timestamp do
    case response() do
      {:ok, body} ->
        epoch = body["timestamp"]
        Timex.parse("#{epoch}", "{s-epoch}")

      _ ->
        Logger.warn("Error when try to get timestamp from body")
        {:error, :api_error}
    end
  end
end
