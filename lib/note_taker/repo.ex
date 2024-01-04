defmodule NoteTaker.Repo do
  use Ecto.Repo,
    otp_app: :note_taker,
    adapter: Ecto.Adapters.Postgres
end
