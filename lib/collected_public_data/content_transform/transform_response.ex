defmodule CollectedPublicData.ContentTransform.TransformResponse do
  use Ecto.Schema
  import Ecto.Changeset

  schema "content_transform_response" do
    field :type_url, :string
    field :in_sha256, :string
    field :in_media_type, :string
    field :out_sha256, :string
    field :out_media_type, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transform_response, attrs) do
    transform_response
    |> cast(attrs, [:type_url, :in_sha256, :in_media_type, :out_sha256, :out_media_type])
    |> validate_required([:type_url, :in_sha256, :in_media_type, :out_sha256, :out_media_type])
  end
end
