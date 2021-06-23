defmodule GithubEvents.Account do
  @moduledoc """
       Account module is responsible for manipulating user details
  """

  alias GithubEvents.Accounts.User
  alias GithubEvents.Repo

  alias Ueberauth.Auth

  @doc """
  saves user into the database
  """

  @spec create_user(map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_user(attr) do
    attr
    |> change_user()
    |> Repo.insert()
    |> IO.inspect(label: "========================")
  end

  @doc """
  list all users saved in the database
  """

  @spec list_users() :: [User.t(), ...]
  def list_users do
    Repo.all(User)
  end

  @doc """
  fetch user whose name matches
  """

  def get_user(owner) do
    Repo.get_by(User, owner: owner)
  end

  @doc """
  fetch user whose uid matches
  """

  def get_by_id(id) do
    Repo.get(User, id)
  end

  @doc """
  returns user repos
  """
  @spec user_repos(String.t()) :: [String.t(), ...] | []
  def user_repos(owner) do
    case get_user(owner) do
      nil -> []
      user -> user.repo
    end
  end

  @spec change_user(map()) :: Ecto.Changeset.t()
  def change_user(attr) do
    %User{}
    |> User.changeset(attr)
  end

  def find_or_create(%Auth{} = auth) do
    case get_by_id(auth.uid) do
      nil ->
        create_user(basic_info(auth))

      user ->
        {:ok, user}
    end
  end

  # github does it this way
  defp avatar_from_auth(%{info: %{urls: %{avatar_url: image}}}), do: image

  # default case if nothing matches
  defp avatar_from_auth(auth) do
    nil
  end

  defp basic_info(auth) do
    %{uid: auth.uid, owner: name_from_auth(auth), avatar: avatar_from_auth(auth)}
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name =
        [auth.info.first_name, auth.info.last_name]
        |> Enum.filter(&(&1 != nil and &1 != ""))

      if Enum.empty?(name) do
        auth.info.nickname
      else
        Enum.join(name, " ")
      end
    end
  end
end
