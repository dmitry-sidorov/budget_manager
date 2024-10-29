# BudgetManager

App for planing and counting your finances.

## Stack

- Elixir
- Phoenix Framework
- Postgres DB
- LiveView + Mishka UI Library [`Chelekom`](https://mishka.tools/chelekom/docs)

To start your Phoenix server:

- Create database container `docker run --name budget_manager_dev -p 5432:5432 -e POSTGRES_USER=budget_manager_user -e POSTGRES_PASSWORD=budget_manager_password -d postgres`
- Run `mix setup` to install and setup dependencies
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:5566`](http://localhost:5566) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).
