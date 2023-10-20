defmodule CollectedPublicData.Repo.Migrations.CreateContentTransformResponse do
  use Ecto.Migration

  def change do
    create table(:content_transform_response) do
      add :type_url, :string
      add :in_media_type, :string
      add :in_sha256, :string
      add :out_media_type, :string
      add :out_sha256, :string

      timestamps(type: :utc_datetime)
    end

    # This index helps query:
    # Has this transform been done before?
    # List all Collected.Press Markdown rendering transforms.
    create unique_index(:content_transform_response, [:type_url, :in_media_type, :in_sha256],
             name: :content_transform_in
           )

    # This index helps query:
    # List all Markdown -> HTML transforms. e.g. rendering
    # List all Markdown -> Markdown transforms. e.g. prettifying
    # List all HTML -> HTML transforms. e.g. minifying
    create index(:content_transform_response, [:in_media_type, :out_media_type])

    # This index helps query:
    # Lookup what this Markdown has been transformed into.
    create index(:content_transform_response, [:in_media_type, :in_sha256])

    # This index helps query:
    # Lookup which source Markdown this HTML is from.
    create index(:content_transform_response, [:out_media_type, :out_sha256])
  end
end
