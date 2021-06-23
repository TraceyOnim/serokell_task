defmodule GithubEventsWeb.Util do
  @moduledoc """
  This Util module contains functions that can be invoked in more than one module in live folder
  """

  @doc """
  fetches github user profile
  """
  @spec github_user_profile!(String.t()) :: map() | nil
  def github_user_profile!(github_user) do
    case HTTPoison.get!("https://api.github.com/users/#{github_user}") do
      %{status_code: 200} = profile -> Jason.decode!(profile.body)
      _ -> nil
    end
  end

  @doc """
  Fetches github user repos
  """
  @spec fetch_repos!(String.t()) :: [String.t(), ...] | nil
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
