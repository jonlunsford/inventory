# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :inventory,
  ecto_repos: [Inventory.Repo]

# Configures the endpoint
config :inventory, Inventory.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ZJ7+JylvwPaA0rp5WTP6nPl6ZsC5QmwMCZLSuNTHwcEEnxxP0SIc65TvX1wcPRg0",
  render_errors: [view: Inventory.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Inventory.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
