defmodule GithubEvents.AccountTest do
  use GithubEvents.DataCase
  alias GithubEvents.Account
  alias GithubEvents.Accounts.User

  test "create_user/1 save user into the db" do
    valid_attr = %{
      owner: "Tracey Onim",
      repo: ["TraceyOnim/040-simple-search-with-phoenix"],
      avatar: "avatar.png"
    }

    {:ok, %User{owner: "Tracey Onim"}} = Account.create_user(valid_attr)
  end

  test "list_users/0 list all users from database" do
    for name <- ["Tracey Onim", "Tee Pendo", "Lecious Pendo"] do
      valid_attr = %{
        owner: name,
        repo: ["#{name}/040-simple-search-with-phoenix"],
        avatar: "avatar.png"
      }

      Account.create_user(valid_attr)
    end

    assert Account.list_users() |> Enum.count() == 3
  end
end
