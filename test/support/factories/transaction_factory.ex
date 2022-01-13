defmodule Coin.TransactionFactory do
  defmacro __using__(_opts) do
    quote do
      def transaction_factory do
        %Coin.Exchange.Transaction{
          first_coin: "EUR",
          final_coin: "BRL",
          final_value: 633,
          first_value: 100,
          timestamps: DateTime.utc_now()
        }
      end
    end
  end
end
