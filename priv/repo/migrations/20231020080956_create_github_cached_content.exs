defmodule CollectedPublicData.Repo.Migrations.CreateGithubCachedContent do
  use Ecto.Migration

  def change do
    create table(:github_cached_content) do
      add :owner, :string
      add :repo, :string
      add :sha, :string
      add :path, :string
      add :content, :binary
      add :content_type, :string

      timestamps(type: :utc_datetime)
    end
  end
end
