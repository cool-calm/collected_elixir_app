defmodule CollectedPublicData.Repo.Migrations.CreateMarkdownCachedContent do
  use Ecto.Migration

  def change do
    create table(:markdown_cached_content) do
      add :sha256, :string, null: false, size: 64
      add :size, :integer, null: false
      add :content, :binary, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
