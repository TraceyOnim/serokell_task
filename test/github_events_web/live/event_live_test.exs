defmodule GithubEventsWeb.EventLiveTest do
  use GithubEventsWeb.ConnCase

  import Phoenix.LiveViewTest
  alias GithubEvents.Account

  test "disconnected and connected render", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/github_events")
    assert html =~ "Github Pull Request Events"
  end

  test "application user can see github user repos", %{conn: conn} do
    valid_attr = %{
      owner: "Tracey Onim",
      repo: ["TraceyOnim/040-simple-search-with-phoenix"],
      avatar: "avatar.png"
    }

    Account.create_user(valid_attr)
    {:ok, view, _html} = live(conn, "/github_events?owner=Tracey+Onim")
    html = render(view)

    assert html =~ "<option value=\"TraceyOnim/040-simple-search-with-phoenix\">"
  end

  test "application user can remap to github user to another github user in the repo", %{
    conn: conn
  } do
    valid_attr = %{
      owner: "Beam Kenya",
      repo: ["beamkenya/ex_pesa"],
      avatar: "avatar.png"
    }

    Account.create_user(valid_attr)

    {:ok, view, _html} = live(conn, "/github_events?owner=BEAM+Kenya")

    html = render_change(view, "sync", %{"repo" => "beamkenya/ex_pesa"})

    # one of the contributor in the repo
    assert html =~ "<td>Tracey Onim</td>"

    html = render_patch(view, "/github_events?remapped_user=TraceyOnim")
    # assert user can see remapped user repos
    assert html =~ "<option value=\"TraceyOnim/040-simple-search-with-phoenix\">"
  end
end
