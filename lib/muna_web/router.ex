defmodule MunaWeb.Router do
  use MunaWeb, :router

  import MunaWeb.UserAuth

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {MunaWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", MunaWeb do
    pipe_through(:browser)

    live("/", DeckLive.Index, :index)
  end

  # Other scopes may use custom stacks.
  # scope "/api", MunaWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:muna, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: MunaWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end

  ## Authentication routes

  scope "/", MunaWeb do
    pipe_through([:browser, :redirect_if_user_is_authenticated])

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{MunaWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live("/users/register", UserRegistrationLive, :new)
      live("/users/log_in", UserLoginLive, :new)
      live("/users/reset_password", UserForgotPasswordLive, :new)
      live("/users/reset_password/:token", UserResetPasswordLive, :edit)
    end

    post("/users/log_in", UserSessionController, :create)
  end

  scope "/", MunaWeb do
    pipe_through([:browser, :require_authenticated_user])

    live_session :require_authenticated_user,
      on_mount: [{MunaWeb.UserAuth, :ensure_authenticated}] do
      live("/users/settings", UserSettingsLive, :edit)
      live("/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email)

      # == Decks =================================
      live("/decks", DeckLive.Index, :index)
      live("/decks/new", DeckLive.Index, :new)
      live("/decks/:id/edit", DeckLive.Index, :edit)

      live("/decks/:id", DeckLive.Show, :show)
      live("/decks/:id/show/edit", DeckLive.Show, :edit)

      # == Cards =================================
      live("/decks/:deck_id/cards", CardLive.Index, :index)
      live("/decks/:deck_id/cards/new", CardLive.Index, :new)
      live("/decks/:deck_id/cards/:id/edit", CardLive.Index, :edit)

      live("/decks/:deck_id/cards/:id", CardLive.Show, :show)
      live("/decks/:deck_id/cards/:id/show/edit", CardLive.Show, :edit)
    end
  end

  scope "/", MunaWeb do
    pipe_through([:browser])

    delete("/users/log_out", UserSessionController, :delete)

    live_session :current_user,
      on_mount: [{MunaWeb.UserAuth, :mount_current_user}] do
      live("/users/confirm/:token", UserConfirmationLive, :edit)
      live("/users/confirm", UserConfirmationInstructionsLive, :new)
    end
  end
end
