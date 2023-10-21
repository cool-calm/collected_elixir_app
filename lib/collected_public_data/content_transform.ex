defmodule CollectedPublicData.ContentTransform do
  @moduledoc """
  The ContentTransform context.
  """

  import Ecto.Query, warn: false
  require Logger
  alias CollectedPublicData.ContentCache.HTMLContent
  alias CollectedPublicData.ContentCache
  alias CollectedPublicData.Repo

  alias CollectedPublicData.ContentTransform.TransformResponse

  @doc """
  Returns the list of content_transform_response.

  ## Examples

      iex> list_content_transform_response()
      [%TransformResponse{}, ...]

  """
  def list_content_transform_response do
    Repo.all(TransformResponse)
  end

  def list_outputs_of(in_media_type, in_sha256) do
    TransformResponse
    |> where(in_media_type: ^in_media_type, in_sha256: ^in_sha256)
    |> Repo.all()
  end

  def list_inputs_to(out_media_type, out_sha256) do
    TransformResponse
    |> where(out_media_type: ^out_media_type, out_sha256: ^out_sha256)
    |> Repo.all()
  end

  @doc """
  Gets a single transform_response.

  Raises `Ecto.NoResultsError` if the Transform response does not exist.

  ## Examples

      iex> get_transform_response!(123)
      %TransformResponse{}

      iex> get_transform_response!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transform_response!(id), do: Repo.get!(TransformResponse, id)

  @doc """
  Creates a transform_response.

  ## Examples

      iex> create_transform_response(%{field: value})
      {:ok, %TransformResponse{}}

      iex> create_transform_response(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transform_response(attrs \\ %{}) do
    %TransformResponse{}
    |> TransformResponse.changeset(attrs)
    |> Repo.insert(on_conflict: :nothing)
  end

  def render_markdown(sha256) do
    type_url = "wss://collected.press/1/ws"

    case Repo.get_by(TransformResponse,
           type_url: type_url,
           in_media_type: "text/markdown",
           in_sha256: sha256
         ) do
      %{out_sha256: out_sha256} ->
        Logger.debug("Using CACHED Markdown -> HTML")
        ContentCache.get_html_content_with_sha256!(out_sha256)

      nil ->
        # html = GenServer.call(CollectedPressWs, {:markdown_to_html, content})
        markdown = ContentCache.get_markdown_content_with_sha256!(sha256)
        html = CollectedPressWs.markdown_to_html(markdown.content)

        {:ok, html_content} = Repo.transaction(fn ->
          {:ok, html_content} = ContentCache.create_html_content(%{"content" => html})
          {:ok, _} = create_transform_response(%{
            type_url: type_url,
            in_media_type: "text/markdown",
            in_sha256: sha256,
            out_media_type: "text/html",
            out_sha256: html_content.sha256
          })
          html_content
        end)
        html_content
    end
    # |> case do
    #   %HTMLContent{content: html_text} ->
    #     html_text
    # end
  end

  @doc """
  Updates a transform_response.

  ## Examples

      iex> update_transform_response(transform_response, %{field: new_value})
      {:ok, %TransformResponse{}}

      iex> update_transform_response(transform_response, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transform_response(%TransformResponse{} = transform_response, attrs) do
    transform_response
    |> TransformResponse.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transform_response.

  ## Examples

      iex> delete_transform_response(transform_response)
      {:ok, %TransformResponse{}}

      iex> delete_transform_response(transform_response)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transform_response(%TransformResponse{} = transform_response) do
    Repo.delete(transform_response)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transform_response changes.

  ## Examples

      iex> change_transform_response(transform_response)
      %Ecto.Changeset{data: %TransformResponse{}}

  """
  def change_transform_response(%TransformResponse{} = transform_response, attrs \\ %{}) do
    TransformResponse.changeset(transform_response, attrs)
  end
end
