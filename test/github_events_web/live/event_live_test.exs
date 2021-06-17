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

  # describe "GITHUG PULL REQUEST EVENTS:" do
  #   test "are displayed for a given specified repo", %{conn: conn} do
  #     GithubEvents.SyncClient.start_link("beamkenya/ex_pesa") |> IO.inspect()
  #     Process.sleep(20000)
  #     {:ok, _view, html} = live(conn, "/github_events")
  #     IO.inspect(html)
  #   end
  # end
end
