defmodule MunaWeb.UserRegistrationLive do
  use MunaWeb, :live_view

  alias Muna.Accounts
  alias Muna.Accounts.User

  def render(assigns) do
    ~H"""
    <div class="mx-auto">
      <p id="_test_register_intro" class="mb-4">Welcome to Muna</p>
      <.simple_form
        :let={f}
        id="registration_form"
        for={@changeset}
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
        action={~p"/users/log_in?_action=registered"}
        method="post"
        as={:user}
      >
        <.error :if={@changeset.action == :insert}>
          Oops, something went wrong! Please check the errors below.
        </.error>

        <div class="flex flex-col sm:flex-row sm:space-x-4 space-y-2 sm:space-y-0">
          <.input
            label="Email"
            placeholder="Enter email address ..."
            field={{f, :email}}
            type="email"
            required
          />
          <.input
            label="Password"
            placeholder="Enter password"
            field={{f, :password}}
            type="password"
            required
          />
        </div>

        <:actions>
          <.button phx-disable-with="Creating account..." class="w-full">Sign up</.button>
        </:actions>
      </.simple_form>
      <div class="flex flex-col items-center mt-3">
        <.link id="_test_login_link" class="text-sm" href={~p"/users/log_in"}>Already have an account? Log in</.link>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})
    socket = assign(socket, changeset: changeset, trigger_submit: false)
    {:ok, socket, temporary_assigns: [changeset: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, assign(socket, trigger_submit: true, changeset: changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign(socket, changeset: Map.put(changeset, :action, :validate))}
  end
end
