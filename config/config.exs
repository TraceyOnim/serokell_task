# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :github_events,
  ecto_repos: [GithubEvents.Repo]

# Configures the endpoint
config :github_events, GithubEventsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "alCyraqtKz6NFNfFyvENOEJYzX6uliAF270HI3CcMhhbyPSnR2EhuzyZbetgvZV9",
  render_errors: [view: GithubEventsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: GithubEvents.PubSub,
  live_view: [signing_salt: "WRriBkqW"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "user:email", allow_private_emails: true]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "531d1372b526a64f88a1",
  client_secret: "59f84e63b005a523ae64cc52a2ff36b61cbb5cb9"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
