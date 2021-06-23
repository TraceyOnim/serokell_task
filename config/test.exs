use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :github_events, GithubEvents.Repo,
  username: "postgres",
  password: "postgres",
  database: "github_events_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :github_events, GithubEventsWeb.Endpoint,
  http: [port: 4002],
  server: false

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "user:email", allow_private_emails: true]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "531d1372b526a64f8y91",
  client_secret: "59f84e63b005a523ae64cc52a2ff36b61cgg5cn9"

# Print only warnings and errors during test
config :logger, level: :warn
