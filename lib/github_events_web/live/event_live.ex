defmodule GithubEventsWeb.EventLive do
  use GithubEventsWeb, :live_view

  alias GithubEvents.Account
  alias Phoenix.PubSub
  alias GithubEventsWeb.Util

  @impl true
  def mount(_params, _session, socket) do
    PubSub.subscribe(GithubEvents.PubSub, "PR_events")
    {:ok, socket |> assign(payloads: [], repos: [], contributors: [])}
  end

  @impl true
  def render(assigns) do
    ~L"""
      <div class="container">
      <div class="row">
      <div class="column column-30">
      <h3>Github Pull Request Events </h3>
       <form phx-change="sync">
      <select name="repo">
        <option value="all" selected>All</option>
        <%= for repo <- @repos do %>
        <option value="<%= repo %>"><%= repo %></option>
        <% end %>
      </select>
      </form>
      <table>
      <tr>
      <th>url</th>
      <th>state</th>
      <th>ceated_at</th>
      <th>updated_at</th>
      <th>merged_at</th>
      <th>closed_at</th>
      <th>assignee</th>
      </tr>
      
      <%= for payload <- @payloads do %>
      <tr>
      <td><a href='<%= payload["url"] %>'>pull request</td>
      <td><%= payload["state"] %></td>
      <td><%= payload["created_at"] %></td>
      <td><%= payload["updated_at"] %></td>
      <td><%= payload["merged_at"] %></td>
      <td><%= payload["closed_at"] %></td>
      <td><%= payload["assignee"] %></td>
      <td><button>View</button></td>
       </tr>
      <% end %>
      
      </table>
      </div>
      <div class="column column-offset-15">
      <h4>Repo contributors</h4>
      <table>
    <%= for contributor <- @contributors do %>
    <tr>
    <td><%= contributor %></td>
    <td><%= live_patch "Events", to: Routes.live_path(@socket, GithubEventsWeb.EventLive, remapped_user: "#{contributor}") %></td>
     </tr>
    <% end %>
    <table>
      </div>
      </div>
      </div>
    """
  end

  @impl true
  def handle_params(%{"owner" => owner}, url, socket) do
    {:noreply, socket |> assign(repos: Account.user_repos(owner))}
  end

  @impl true
  def handle_params(%{"remapped_user" => remapped_user}, url, socket) do
    {:noreply, socket |> _remapped_user_repos(remapped_user)}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("sync", %{"repo" => repo}, socket) do
    GithubEvents.SyncClient.start_link(repo)

    {:noreply, socket |> repo_contributors(repo)}
  end

  @impl true
  def handle_info({:pull_request_events, payloads}, socket) do
    {:noreply, socket |> assign(payloads: Jason.decode!(payloads))}
  end

  defp repo_contributors(socket, repo) do
    contributors =
      Enum.map(repo_contributors(repo), fn contributor ->
        profile = Util.github_user_profile!(contributor)
        profile["name"]
      end)

    assign(socket, contributors: contributors)
  end

  defp repo_contributors(repo) do
    case HTTPoison.get("https://api.github.com/repos/#{repo}/contributors") do
      {:ok, response} -> response.body |> Jason.decode!() |> Enum.map(& &1["login"])
      {:error, _} -> []
    end
  end

  defp _remapped_user_repos(socket, remapped_user) do
    assign(socket, repos: remapped_user |> Util.fetch_repos!() |> Util.parse_repos())
  end
end
