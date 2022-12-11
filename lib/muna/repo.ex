defmodule Muna.Repo do
  use Ecto.Repo,
    otp_app: :muna,
    adapter: Ecto.Adapters.Postgres
end
