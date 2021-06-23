defmodule GithubEvents.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  schema "users" do
    field :owner, :string
    field :repo, {:array, :string}
    field :avatar, :string
  end

  def changeset(user, attr \\ %{}) do
    user
    |> cast(attr, [:owner, :repo, :avatar])
  end
end
