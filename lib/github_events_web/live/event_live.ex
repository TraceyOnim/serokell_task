defmodule GithubEventsWeb.EventLive do
  use GithubEventsWeb, :live_view

  alias GithubEvents.Account
  alias Phoenix.PubSub

  @impl true
  def mount(_params, _session, socket) do
    PubSub.subscribe(GithubEvents.PubSub, "PR_events")
    {:ok, socket |> assign(payloads: [], repos: [])}
  end

  @impl true
  def render(assigns) do
    ~L"""
      <div class="container">
      <select name="repos">
        <option value="all" selected>All</option>
        <%= for repo <- @repos do %>
        <option value="<%= repo %>"><%= repo %></option>
        <% end %>
      </select>
      <h1>Github Pull Request Events </h1>
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
    """
  end

  @impl true
  def handle_params(%{"owner" => owner}, url, socket) do
    {:noreply, socket |> assign(repos: user_repos(owner))}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({:pull_request_events, payloads}, socket) do
    {:noreply, socket |> assign(payloads: Jason.decode!(payloads))}
  end

  defp user_repos(owner) do
    user = Account.get_user(owner)
    user.repo
  end
end
