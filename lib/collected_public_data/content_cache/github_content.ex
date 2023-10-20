defmodule CollectedPublicData.ContentCache.GitHubContent do
  use Ecto.Schema
  import Ecto.Changeset

  schema "github_cached_content" do
    field :owner, :string
    field :path, :string
    field :repo, :string
    field :sha, :string
    field :content, :binary
    field :content_type, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(github_content, attrs) do
    github_content
    |> cast(attrs, [:owner, :repo, :sha, :path, :content, :content_type])
    |> validate_required([:owner, :repo, :sha, :path, :content, :content_type])
  end
end
