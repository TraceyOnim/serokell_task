defmodule GithubEvents.Account do
  @moduledoc """
       Account module is responsible for manipulating user details
  """

  alias GithubEvents.Accounts.User
  alias GithubEvents.Repo

  @doc """
  saves user into the database
  """

  @spec create_user(map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_user(attr) do
    attr
    |> change_user()
    |> Repo.insert()
  end

  @spec change_user(map()) :: Ecto.Changeset.t()
  def change_user(attr) do
    %User{}
    |> User.changeset(attr)
  end
end
