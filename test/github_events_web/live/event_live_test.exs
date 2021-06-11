defmodule GithubEventsWeb.EventLiveTest do
  use GithubEventsWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/github_events")
    assert html =~ "Github Pull Request Events"
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
