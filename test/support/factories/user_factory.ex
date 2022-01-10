defmodule Coin.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %Coin.Accounts.User{
          name: Faker.Person.name(),
          email: sequence(:email, &"test-#{&1}@example.com")
        }
      end
    end
  end
end
