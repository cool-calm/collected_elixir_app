defmodule CollectedPublicData.ContentCache do
  @moduledoc """
  The ContentCache context.
  """

  import Ecto.Query, warn: false
  alias CollectedPublicData.Repo
  alias Ecto.Changeset

  alias CollectedPublicData.ContentCache.GitHubContent

  @doc """
  Returns the list of github_cached_content.

  ## Examples

      iex> list_github_cached_content()
      [%GitHubContent{}, ...]

  """
  def list_github_cached_content do
    Repo.all(GitHubContent)
  end

  @doc """
  Gets a single github_content.

  Raises `Ecto.NoResultsError` if the Git hub content does not exist.

  ## Examples

      iex> get_github_content!(123)
      %GitHubContent{}

      iex> get_github_content!(456)
      ** (Ecto.NoResultsError)

  """
  def get_github_content!(id), do: Repo.get!(GitHubContent, id)

  @doc """
  Creates a github_content.

  ## Examples

      iex> create_github_content(%{field: value})
      {:ok, %GitHubContent{}}

      iex> create_github_content(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_github_content(attrs \\ %{}) do
    %GitHubContent{}
    |> GitHubContent.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a github_content.

  ## Examples

      iex> update_github_content(github_content, %{field: new_value})
      {:ok, %GitHubContent{}}

      iex> update_github_content(github_content, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_github_content(%GitHubContent{} = github_content, attrs) do
    github_content
    |> GitHubContent.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a github_content.

  ## Examples

      iex> delete_github_content(github_content)
      {:ok, %GitHubContent{}}

      iex> delete_github_content(github_content)
      {:error, %Ecto.Changeset{}}

  """
  def delete_github_content(%GitHubContent{} = github_content) do
    Repo.delete(github_content)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking github_content changes.

  ## Examples

      iex> change_github_content(github_content)
      %Ecto.Changeset{data: %GitHubContent{}}

  """
  def change_github_content(%GitHubContent{} = github_content, attrs \\ %{}) do
    GitHubContent.changeset(github_content, attrs)
  end

  alias CollectedPublicData.ContentCache.WasmContent

  @doc """
  Returns the list of wasm_cached_content.

  ## Examples

      iex> list_wasm_cached_content()
      [%WasmContent{}, ...]

  """
  def list_wasm_cached_content do
    Repo.all(WasmContent)
  end

  @doc """
  Gets a single wasm_content.

  Raises `Ecto.NoResultsError` if the Wasm content does not exist.

  ## Examples

      iex> get_wasm_content!(123)
      %WasmContent{}

      iex> get_wasm_content!(456)
      ** (Ecto.NoResultsError)

  """
  def get_wasm_content!(id), do: Repo.get!(WasmContent, id)

  @doc """
  Creates a wasm_content.

  ## Examples

      iex> create_wasm_content(%{field: value})
      {:ok, %WasmContent{}}

      iex> create_wasm_content(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_wasm_content(attrs \\ %{}) do
    %WasmContent{}
    |> WasmContent.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a wasm_content.

  ## Examples

      iex> update_wasm_content(wasm_content, %{field: new_value})
      {:ok, %WasmContent{}}

      iex> update_wasm_content(wasm_content, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_wasm_content(%WasmContent{} = wasm_content, attrs) do
    wasm_content
    |> WasmContent.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a wasm_content.

  ## Examples

      iex> delete_wasm_content(wasm_content)
      {:ok, %WasmContent{}}

      iex> delete_wasm_content(wasm_content)
      {:error, %Ecto.Changeset{}}

  """
  def delete_wasm_content(%WasmContent{} = wasm_content) do
    Repo.delete(wasm_content)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking wasm_content changes.

  ## Examples

      iex> change_wasm_content(wasm_content)
      %Ecto.Changeset{data: %WasmContent{}}

  """
  def change_wasm_content(%WasmContent{} = wasm_content, attrs \\ %{}) do
    WasmContent.changeset(wasm_content, attrs)
  end

  def upsert_content(content_type, changeset) do
    changeset
    |> Changeset.unique_constraint(:sha256)
    |> Repo.insert()
    |> case do
      {:error, changeset} ->
        {:ok, get_content_by_sha256!(content_type, Changeset.get_field(changeset, :sha256))}

      other ->
        other
    end
  end

  alias CollectedPublicData.ContentCache.MarkdownContent

  @doc """
  Returns the list of markdown_cached_content.

  ## Examples

      iex> list_markdown_cached_content()
      [%MarkdownContent{}, ...]

  """
  def list_markdown_cached_content do
    Repo.all(MarkdownContent)
  end

  @doc """
  Gets a single markdown_content.

  Raises `Ecto.NoResultsError` if the Markdown content does not exist.

  ## Examples

      iex> get_markdown_content!(123)
      %MarkdownContent{}

      iex> get_markdown_content!(456)
      ** (Ecto.NoResultsError)

  """
  def get_markdown_content!(id), do: Repo.get!(MarkdownContent, id)
  def get_markdown_content_with_sha256!(sha256), do: Repo.get_by!(MarkdownContent, sha256: sha256)

  @doc """
  Creates markdown content if it doesn’t already exist.
  """
  def create_markdown_content(attrs \\ %{}) do
    %MarkdownContent{}
    |> MarkdownContent.changeset(attrs)
    |> then(&upsert_content(:markdown, &1))
  end

  @doc """
  Updates a markdown_content.

  ## Examples

      iex> update_markdown_content(markdown_content, %{field: new_value})
      {:ok, %MarkdownContent{}}

      iex> update_markdown_content(markdown_content, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_markdown_content(%MarkdownContent{} = markdown_content, attrs) do
    markdown_content
    |> MarkdownContent.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a markdown_content.

  ## Examples

      iex> delete_markdown_content(markdown_content)
      {:ok, %MarkdownContent{}}

      iex> delete_markdown_content(markdown_content)
      {:error, %Ecto.Changeset{}}

  """
  def delete_markdown_content(%MarkdownContent{} = markdown_content) do
    Repo.delete(markdown_content)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking markdown_content changes.

  ## Examples

      iex> change_markdown_content(markdown_content)
      %Ecto.Changeset{data: %MarkdownContent{}}

  """
  def change_markdown_content(%MarkdownContent{} = markdown_content, attrs \\ %{}) do
    MarkdownContent.changeset(markdown_content, attrs)
  end

  alias CollectedPublicData.ContentCache.HTMLContent

  @doc """
  Returns the list of html_cached_content.

  ## Examples

      iex> list_html_cached_content()
      [%HTMLContent{}, ...]

  """
  def list_html_cached_content do
    Repo.all(HTMLContent)
  end

  @doc """
  Gets a single html_content.

  Raises `Ecto.NoResultsError` if the Html content does not exist.

  ## Examples

      iex> get_html_content!(123)
      %HTMLContent{}

      iex> get_html_content!(456)
      ** (Ecto.NoResultsError)

  """
  def get_html_content!(id), do: Repo.get!(HTMLContent, id)
  def get_html_content_with_sha256!(sha256), do: Repo.get_by!(HTMLContent, sha256: sha256)

  @doc """
  Creates a HTML content if it doesn’t already exist.
  """
  def create_html_content(attrs \\ %{}) do
    %HTMLContent{}
    |> HTMLContent.changeset(attrs)
    |> then(&upsert_content(:html, &1))
  end

  @doc """
  Updates a html_content.

  ## Examples

      iex> update_html_content(html_content, %{field: new_value})
      {:ok, %HTMLContent{}}

      iex> update_html_content(html_content, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_html_content(%HTMLContent{} = html_content, attrs) do
    html_content
    |> HTMLContent.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a html_content.

  ## Examples

      iex> delete_html_content(html_content)
      {:ok, %HTMLContent{}}

      iex> delete_html_content(html_content)
      {:error, %Ecto.Changeset{}}

  """
  def delete_html_content(%HTMLContent{} = html_content) do
    Repo.delete(html_content)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking html_content changes.

  ## Examples

      iex> change_html_content(html_content)
      %Ecto.Changeset{data: %HTMLContent{}}

  """
  def change_html_content(%HTMLContent{} = html_content, attrs \\ %{}) do
    HTMLContent.changeset(html_content, attrs)
  end

  def get_content_by_sha256!(:markdown, sha256), do: get_markdown_content_with_sha256!(sha256)
  def get_content_by_sha256!(:html, sha256), do: get_html_content_with_sha256!(sha256)
end
