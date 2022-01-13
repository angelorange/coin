defmodule Coin.TransactionFactory do
  defmacro __using__(_opts) do
    quote do
      def transaction_factory do
        %Coin.Exchange.Transaction{
          first_coin: "EUR",
          final_coin: "BRL",
          first_value: 100,
          final_value: 633
        }
      end
    end
  end
end
