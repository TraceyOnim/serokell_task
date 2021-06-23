defmodule GithubEventsWeb.Auth do
  @moduledoc """
  Auth plug, checks for the current user and adds them to assigns.
  """
  import Plug.Conn
  use GithubEventsWeb, :controller

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      current_user = get_session(conn, :current_user)
      assign(conn, :current_user, current_user)
    end
  end
end
