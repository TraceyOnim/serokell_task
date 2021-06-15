defmodule GithubEventsWeb.EventLiveTest do
  use GithubEventsWeb.ConnCase

  import Phoenix.LiveViewTest
  alias GithubEvents.Accounts.User
  alias GithubEvents.Repo

  describe "MAPPING GITHUB USER:" do
    setup %{conn: conn} do
      {:ok, view, _html} = live(conn, "profile")
      render_change(view, "confirm", %{"user" => "TraceyOnim"})
      render_click(view, "save")
      [conn: conn]
    end

    test "can be done by the application user" do
      %User{} = Repo.get_by(User, owner: "Tracey Onim")
    end

    test "application user can see mapped users", %{conn: conn} do
      {:ok, _view, html} = live(conn, "profile")
      assert html =~ "<td>Tracey Onim</td>"
    end
  end
end
