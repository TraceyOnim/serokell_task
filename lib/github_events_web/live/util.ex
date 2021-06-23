defmodule GithubEventsWeb.Util do
  def github_user_profile!(github_user) do
    case HTTPoison.get!("https://api.github.com/users/#{github_user}") do
      %{status_code: 200} = profile -> Jason.decode!(profile.body)
      _ -> nil
    end
  end

  def fetch_repos!(owner) do
    case HTTPoison.get!("https://api.github.com/users/#{owner}/repos") do
      %{status_code: 200} = repos -> repos
      _ -> nil
    end
  end

  def parse_repos(nil), do: []

  def parse_repos(repos) do
    repos.body
    |> Jason.decode!()
    |> Enum.map(fn repo -> repo["full_name"] end)
  end
end
