defmodule Txtshr.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # we don't talk about the table name
    :ets.new(:stuff, [:set, :public, :named_table])

    children = [
      # Start the Telemetry supervisor
      TxtshrWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Txtshr.PubSub},
      # Start the Endpoint (http/https)
      TxtshrWeb.Endpoint
      # Start a worker by calling: Txtshr.Worker.start_link(arg)
      # {Txtshr.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Txtshr.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TxtshrWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
