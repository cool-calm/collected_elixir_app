defmodule CollectedPublicData.ContentCache.HTMLContent do
  use Ecto.Schema
  import Ecto.Changeset

  alias CollectedPublicData.ContentCache.SHA

  schema "html_cached_content" do
    field :size, :integer
    field :sha256, :string
    field :content, :binary

    timestamps(type: :utc_datetime)
  end

  def put_content(changeset, content) do
    size = byte_size(content)
    sha256 = SHA.sha256([content])

    changeset
    |> put_change(:content, content)
    |> put_change(:size, size)
    |> put_change(:sha256, sha256)
  end

  def changeset(html_content, attrs) do
    changeset = change(html_content)

    changeset =
      case attrs do
        %{"source_url" => source_url} when is_binary(source_url) ->
          content = Req.get!(source_url, decode_body: false).body

          changeset
          |> put_content(content)

        %{"content" => content} when is_binary(content) ->
          changeset
          |> put_content(content)

        _ ->
          changeset
      end

    changeset =
      changeset
      |> validate_required([:content, :size, :sha256])
  end
end
