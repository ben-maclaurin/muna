defmodule Muna.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      MunaWeb.Telemetry,
      # Start the Ecto repository
      Muna.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Muna.PubSub},
      # Start Finch
      {Finch, name: Muna.Finch},
      # Start the Endpoint (http/https)
      MunaWeb.Endpoint
      # Start a worker by calling: Muna.Worker.start_link(arg)
      # {Muna.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Muna.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MunaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
