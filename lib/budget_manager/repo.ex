defmodule BudgetManager.Repo do
  use Ecto.Repo,
    otp_app: :budget_manager,
    adapter: Ecto.Adapters.Postgres
end
