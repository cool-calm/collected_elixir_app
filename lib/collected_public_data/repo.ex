defmodule CollectedPublicData.Repo do
  use Ecto.Repo,
    otp_app: :collected_public_data,
    adapter: Ecto.Adapters.MyXQL
end
