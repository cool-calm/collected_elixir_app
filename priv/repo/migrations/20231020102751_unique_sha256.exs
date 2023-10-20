defmodule CollectedPublicData.Repo.Migrations.UniqueSha256 do
  use Ecto.Migration

  def change do
    create unique_index(:markdown_cached_content, [:sha256])
    create unique_index(:wasm_cached_content, [:sha256])
  end
end
