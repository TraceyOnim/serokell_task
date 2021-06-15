defmodule GithubEventsWeb.ProfileLive do
  use GithubEventsWeb, :live_view

  alias GithubEvents.Account
  alias GithubEventsWeb.Router.Helpers, as: Routes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(confirm: false, github_user: %{}, mapped_users: Account.list_users())}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="container">
    <div class="row">
    <div class="column column-50">
       <form phx-change="confirm">
      <label for="">Enter Github User</label>
        <input type="text" name="user" id="user"
        />
    </form>
    <div class="row">
    <div class="column">
    <%= if @confirm do %>
    <figure>
      <img src=<%= @github_user[:avatar] %> alt="github user"  height="75" />
      <figcaption><%= @github_user[:name] || "Anonymous" %></figcaption>
    </figure>
    <button phx-click="save">Save</button>
    <% end %>
    </div>
    </div>
    </div>
    <div class="column column-offset-15">
    <table>
    <%= for user <- @mapped_users do %>
    <tr>
    <td><%= user.owner %></td>
    <td><%= live_redirect "Events", to: Routes.live_path(@socket, GithubEventsWeb.EventLive, name: "#{user.owner}") %></td>
     </tr>
    <% end %>
    <table>
    </div>
    </div>
    </div>

    """
  end

  @impl true
  def handle_event("confirm", %{"user" => user}, socket) do
    profile = _make_request!(user)

    {:noreply,
     socket
     |> assign(
       confirm: true,
       github_user: %{avatar: profile["avatar_url"], name: profile["name"], owner: user}
     )}
  end

  @impl true
  def handle_event("save", _params, socket) do
    {:noreply,
     socket |> _create_user() |> push_redirect(to: Routes.live_path(socket, __MODULE__))}
  end

  defp _create_user(socket) do
    github_user = socket.assigns.github_user

    repos =
      github_user[:owner]
      |> _fetch_repos!()
      |> _parse_repos()

    attr = %{owner: github_user[:name], repo: repos, avatar: github_user[:avatar]}

    case Account.create_user(attr) do
      {:ok, _} ->
        socket
        |> put_flash(:info, "mapped to github user successfully")

      _ ->
        socket
        |> put_flash(:error, "Something went wrong, Try Again!!")
    end
  end

  defp _make_request!(github_user) do
    case HTTPoison.get!("https://api.github.com/users/#{github_user}") do
      %{status_code: 200} = profile -> Jason.decode!(profile.body)
      _ -> nil
    end
  end

  defp _fetch_repos!(owner) do
    case HTTPoison.get!("https://api.github.com/users/#{owner}/repos") do
      %{status_code: 200} = repos -> repos
      _ -> nil
    end
  end

  defp _parse_repos(nil), do: []

  defp _parse_repos(repos) do
    repos.body
    |> Jason.decode!()
    |> Enum.map(fn repo -> repo["full_name"] end)
  end
end
