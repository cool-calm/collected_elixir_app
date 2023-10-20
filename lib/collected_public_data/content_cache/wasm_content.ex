defmodule CollectedPublicData.ContentCache.WasmContent do
  use Ecto.Schema
  import Ecto.Changeset

  alias CollectedPublicData.ContentCache.SHA

  schema "wasm_cached_content" do
    field :sha256, :string
    field :size, :integer
    field :content, :binary

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(wasm_content, attrs) do
    changeset = wasm_content |> change()

    # changeset =
    #   wasm_content
    #   |> cast(attrs, [:content])

    changeset =
      case attrs do
        %{"content" => %Plug.Upload{} = upload} ->
          %File.Stat{size: size} = File.stat!(upload.path)
          content = File.read!(upload.path)
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

  # def changeset(wasm_content, attrs) do
  #   changeset = wasm_content
  #   |> cast(attrs, [:content])
  #   |> validate_required([:content])

  #   IO.inspect(attrs)
  #   IO.inspect(changeset)
  #   changeset
  #   # hash = File.stream!(tmp_path, [], 2048) |> Upload.sha256()
  # end
end
