defmodule ExPort.Cache.UserCache do
  use GenServer

  alias ExPort.{Accounts, Accounts.User}

  @moduledoc """
  GenServer which is being used for the user cache.
  """

  # Client

  @doc false
  @spec start_link(keyword) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(args) do
    if Keyword.get(args, :standalone, true) do
      GenServer.start_link(__MODULE__, [], name: __MODULE__)
    else
      GenServer.start_link(__MODULE__, [])
    end
  end

  @doc """
  Update the user. This is used to both save and read the User.
  """
  @spec update_user(%User{}, pid() | nil) :: %User{}
  def update_user(user, pid \\ nil) do
    GenServer.cast(pid || __MODULE__, {:update_user, user})
    user
  end

  @doc """
  Read the data for the user. Can return nil.
  """
  @spec read_user(pid() | nil) :: %User{}
  def read_user(pid \\ nil) do
    GenServer.call(pid || __MODULE__, :read_user)
  end

  # Server

  @impl true
  def handle_call(:read_user, _, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:update_user, user}, _) do
    {:noreply, user}
  end

  @impl true
  def init(_) do
    {:ok, Accounts.first_user!()}
  end
end