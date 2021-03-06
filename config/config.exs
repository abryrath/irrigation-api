# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :iri,
  ecto_repos: [Iri.Repo]

# Configures the endpoint
config :iri, IriWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "W0MHbyn8sWOhbYHXH128lVprHSZWxGCdxZtKU1UhD7dM3XkmFHaStzGmpGROPstO",
  render_errors: [view: IriWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Iri.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "Dpy2W70b"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
