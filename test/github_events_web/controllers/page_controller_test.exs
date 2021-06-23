defmodule GithubEventsWeb.PageControllerTest do
  use GithubEventsWeb.ConnCase

  alias GithubEvents.Accounts.User

  test "application user can log in with github account", %{conn: conn} do
    auth = %Ueberauth.Auth{
      provider: :github,
      info: %{
        first_name: "John",
        last_name: "Doe",
        email: "john.doe@example.com",
        image: "https://example.com/image.jpg",
        name: "John Doe"
      },
      uid: 4_000_000
    }

    conn
    |> bypass_through(GithubEventsWeb.Router, [:browser])
    |> get("/auth/github/callback")
    |> assign(:ueberauth_auth, auth)
    |> GithubEventsWeb.AuthController.callback(%{})

    %User{uid: uid} = GithubEvents.Repo.get_by(User, owner: "John Doe")
    assert uid == auth.uid
  end

  test "user is restricted to access events page if not logged in", %{conn: conn} do
    conn = get(conn, "/github_events")
    assert get_flash(conn, :error) == "Please login first"
  end
end
