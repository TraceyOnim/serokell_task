defmodule GithubEventsWeb.EventLiveTest do
  use GithubEventsWeb.ConnCase

  import Phoenix.LiveViewTest
  alias GithubEvents.Accounts.User
  alias GithubEvents.Repo

  describe "MAPPING GITHUB USER:" do
    test "can be done by the application user", %{conn: conn} do
      {:ok, view, _html} = live(conn, "profile")
      render_change(view, "confirm", %{"user" => "TraceyOnim"})
      render_click(view, "save")
      %User{} = Repo.get_by(User, owner: "Tracey Onim")
    end
  end
end
