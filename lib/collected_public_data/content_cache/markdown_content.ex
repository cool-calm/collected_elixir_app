defmodule CollectedPublicData.ContentCache.MarkdownContent do
  use Ecto.Schema
  import Ecto.Changeset

  alias CollectedPublicData.ContentCache.SHA

  schema "markdown_cached_content" do
    field :size, :integer
    field :sha256, :string
    field :content, :binary

    timestamps(type: :utc_datetime)
  end

  @doc false
  # def changeset(markdown_content, attrs) do
  #   markdown_content
  #   |> cast(attrs, [:sha256, :size, :content])
  #   |> validate_required([:sha256, :size, :content])
  # end

  def changeset(markdown_content, attrs) do
    changeset = markdown_content |> change()

    # changeset =
    #   markdown_content
    #   |> cast(attrs, [:content])

    changeset =
      case attrs do
        %{"source_url" => source_url} when is_binary(source_url) ->
          content = Req.get!(source_url, decode_body: false).body
          IO.inspect(content, label: "CONTENT")
          size = byte_size(content)
          sha256 = SHA.sha256([content])

          changeset
          |> put_change(:content, content)
          |> put_change(:size, size)
          |> put_change(:sha256, sha256)

        _ ->
          changeset
      end

    changeset =
      changeset
      |> validate_required([:content, :size, :sha256])

    IO.inspect(attrs)
    IO.inspect(changeset)

    changeset

    # hash = File.stream!(tmp_path, [], 2048) |> Upload.sha256()
  end
end
