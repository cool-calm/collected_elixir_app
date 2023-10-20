defmodule CollectedPublicData.Repo.Migrations.CreateWasmCachedContent do
  use Ecto.Migration

  def change do
    create table(:wasm_cached_content) do
      add :sha256, :string, null: false, size: 64
      add :size, :bigint, null: false
      add :content, :binary, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
