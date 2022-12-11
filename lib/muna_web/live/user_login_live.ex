defmodule MunaWeb.UserLoginLive do
  use MunaWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto">
      <p id="_test_login_intro" class="mb-4">Welcome back</p>
      <.simple_form
        :let={f}
        id="login_form"
        for={:user}
        action={~p"/users/log_in"}
        as={:user}
        phx-update="ignore"
      >
        <div class="flex flex-col sm:flex-row sm:space-x-4 space-y-2 sm:space-y-0">
          <.input
            placeholder="Enter email address ..."
            field={{f, :email}}
            type="email"
            label="Email"
            required
          />
          <.input
            placeholder="Enter password"
            field={{f, :password}}
            type="password"
            label="Password"
            required
          />
        </div>

        <:actions :let={f}>
          <.input field={{f, :remember_me}} type="checkbox" label="Keep me logged in" />
          <.link href={~p"/users/reset_password"} class="text-sm font-semibold">
            Forgot your password?
          </.link>
        </:actions>
        <:actions>
          <.button phx-disable-with="Sigining in..." class="w-full">
            Sign in <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
      <div class="flex flex-col items-center mt-3">
        <.link id="_test_signup" class="text-sm" href={~p"/users/register"}>Don't have an account? Sign up</.link>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    {:ok, assign(socket, email: email), temporary_assigns: [email: nil]}
  end
end
