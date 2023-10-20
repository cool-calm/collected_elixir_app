defmodule CollectedPublicData.Repo.Migrations.CreateHtmlCachedContent do
  use Ecto.Migration

  def change do
    create table(:html_cached_content) do
      add :sha256, :string
      add :size, :integer
      add :content, :binary

      timestamps(type: :utc_datetime)
    end

    create unique_index(:html_cached_content, [:sha256])
  end
end
