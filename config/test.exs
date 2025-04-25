import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :vocabulary_builder, VocabularyBuilder.Repo,
  username: "root",
  password: "root",
  hostname: "localhost",
  port: 5433,
  database: "vocabulary_builder_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :vocabulary_builder, VocabularyBuilderWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "LFIpqlIOwbdfCF8ed6v4xncyk/mDEymXpyaeODcn5ZkRQRSAeFnBVEYWi7gUShrT",
  server: false

# In test we don't send emails
config :vocabulary_builder, VocabularyBuilder.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
