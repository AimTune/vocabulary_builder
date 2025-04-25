defmodule VocabularyBuilder.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      VocabularyBuilderWeb.Telemetry,
      VocabularyBuilder.Repo,
      {DNSCluster, query: Application.get_env(:vocabulary_builder, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: VocabularyBuilder.PubSub},
      # Start a worker by calling: VocabularyBuilder.Worker.start_link(arg)
      # {VocabularyBuilder.Worker, arg},
      # Start to serve requests, typically the last entry
      VocabularyBuilderWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: VocabularyBuilder.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VocabularyBuilderWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
