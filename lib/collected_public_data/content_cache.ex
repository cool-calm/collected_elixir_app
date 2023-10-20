defmodule CollectedPublicData.ContentCache do
  @moduledoc """
  The ContentCache context.
  """

  import Ecto.Query, warn: false
  alias CollectedPublicData.Repo

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

  @doc """
  Creates a markdown_content.

  ## Examples

      iex> create_markdown_content(%{field: value})
      {:ok, %MarkdownContent{}}

      iex> create_markdown_content(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_markdown_content(attrs \\ %{}) do
    %MarkdownContent{}
    |> MarkdownContent.changeset(attrs)
    |> Repo.insert()
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
end
