defmodule MunaWeb.DeckLive.Index do
  use MunaWeb, :live_view

  alias Muna.Study
  alias Muna.Study.Deck

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:decks, list_decks())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Deck")
    |> assign(:deck, Study.get_deck!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Deck")
    |> assign(:deck, %Deck{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Decks")
    |> assign(:deck, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    deck = Study.get_deck!(id)
    {:ok, _} = Study.delete_deck(deck)

    {:noreply, assign(socket, :decks, list_decks())}
  end

  defp list_decks do
    Study.list_decks()
  end
end
