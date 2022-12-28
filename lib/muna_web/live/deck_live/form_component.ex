defmodule MunaWeb.DeckLive.FormComponent do
  use MunaWeb, :live_component

  alias Muna.Study

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage deck records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="deck-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :name}} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Deck</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{deck: deck} = assigns, socket) do
    changeset = Study.change_deck(deck)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"deck" => deck_params}, socket) do
    changeset =
      socket.assigns.deck
      |> Study.change_deck(deck_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"deck" => deck_params}, socket) do
    save_deck(socket, socket.assigns.action, deck_params)
  end

  defp save_deck(socket, :edit, deck_params) do
    case Study.update_deck(socket.assigns.deck, deck_params) do
      {:ok, _deck} ->
        {:noreply,
         socket
         |> put_flash(:info, "Deck updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_deck(socket, :new, deck_params) do
    case Study.create_deck(deck_params) do
      {:ok, _deck} ->
        {:noreply,
         socket
         |> put_flash(:info, "Deck created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
