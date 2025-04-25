defmodule VocabularyBuilder.Repo do
  use Ecto.Repo,
    otp_app: :vocabulary_builder,
    adapter: Ecto.Adapters.Postgres
end
