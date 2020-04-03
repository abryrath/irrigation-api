defmodule Iri.Repo do
  use Ecto.Repo,
    otp_app: :iri,
    adapter: Ecto.Adapters.Postgres
end
