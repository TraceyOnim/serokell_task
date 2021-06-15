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
end
