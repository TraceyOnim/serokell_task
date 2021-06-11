defmodule GithubEvents.SyncClient do
  use GenServer
  alias Phoenix.PubSub

  def start_link(repo, options \\ []) do
    GenServer.start_link(__MODULE__, repo, options)
  end

  @impl true
  def init(repo) do
    {:ok, repo, {:continue, :sync}}
  end

  @impl true
  def handle_continue(:sync, state) do
    response = HTTPoison.get!("https://api.github.com/repos/#{state}/pulls")
    {:noreply, response, {:continue, :publish}}
  end

  @impl true
  def handle_continue(:publish, response) do
    PubSub.broadcast(GithubEvents.PubSub, "PR_events", {:pull_request_events, response.body})
    {:stop, :normal, []}
  end
end
