# Coin
 
It’s a RESTfull API that converts currencies to others. Currently, the conversion is made between 4 currencies(BRL, USD, EUR, JPY).

## Deps for Linux

- `sudo apt update`
- `sudo apt upgrade`
- `sudo apt install -y build-essential libssl-dev zlib1g-dev automake autoconf libncurses5-dev`

## In loco Setup

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Start Phoenix endpoint with `mix phx.server`
- Run complete tests `mix test`

## Database
  PostgreSQL
  ```
  username: postgres
  password: postgres
  ```

## Using

 You can use postman, or a similar app, to send json to this API.The endpoint and the item's list are below.

## Explanation
To avoid issues with numbers, all the numbers are Integers. 
For example, if you want to send $10.00, you need to send in the request body 1000. 
So, in the other words, everything is in cents.

## Options/ Endpoint
  There's a folder in the project root which is called doc. 
  Inside of this doc, we have the Insomnia json where it has already somethings created there.

### Endpoint

 - Create user ( post /api/users )
  ```
  {
    "user": {
      "email": "nini@gmail.com",
      "name": "nini"
    }
  }
  ```

  - Edit user ( put /api/users/:id )
  ```
  {
    "user": {
      "email": "nini@gmail.com",
      "name": "nini"
    }
  }
  ```


  - Delete user (delete /api/users/:id )

  ```
  - create transactions (post /api/transactions)

  {
    "transaction": {
      "user_id": "1",
      "first_coin": "USD",
      "first_value": 10000,
      "final_coin": "JPY",
    }
  }
  ```

  - Delete transaction (delete /api/transactions/:id )

  - Show transaction (get /api/transactions/:id )

  - list all transactions by user (get /api/transactions?user_id=1)

 ### Features
 The features were split between: 
 - Users
 - Transactions and Api implementation

 ### Chosen Technology motivation
 - Elixir is a very simple language to work with. With The Phoenix Framework, it's even easier to do a lot of things, and also for its speed too.

## Made by

 - [angelorange](https://github.com/angelorange)
