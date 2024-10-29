defmodule BudgetManager.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BudgetManagerWeb.Telemetry,
      BudgetManager.Repo,
      {DNSCluster, query: Application.get_env(:budget_manager, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BudgetManager.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: BudgetManager.Finch},
      # Start a worker by calling: BudgetManager.Worker.start_link(arg)
      # {BudgetManager.Worker, arg},
      # Start to serve requests, typically the last entry
      BudgetManagerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BudgetManager.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BudgetManagerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
