defmodule GithubEvents.Repo do
  use Ecto.Repo,
    otp_app: :github_events,
    adapter: Ecto.Adapters.Postgres
end
