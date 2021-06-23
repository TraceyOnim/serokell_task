defmodule GithubEvents.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :uid, :integer
      add :owner, :string
      add :repo, {:array, :string}
      add :avatar, :string
    end
  end
end
