defmodule CollectedPublicDataWeb.GitHubContentController do
  use CollectedPublicDataWeb, :controller

  alias CollectedPublicData.ContentCache
  alias CollectedPublicData.ContentCache.GitHubContent

  def index(conn, _params) do
    github_cached_content = ContentCache.list_github_cached_content()
    render(conn, :index, github_cached_content: github_cached_content)
  end

  def new(conn, _params) do
    changeset = ContentCache.change_github_content(%GitHubContent{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"github_content" => github_content_params}) do
    case ContentCache.create_github_content(github_content_params) do
      {:ok, github_content} ->
        conn
        |> put_flash(:info, "Git hub content created successfully.")
        |> redirect(to: ~p"/github_cached_content/#{github_content}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    github_content = ContentCache.get_github_content!(id)
    render(conn, :show, github_content: github_content)
  end

  def edit(conn, %{"id" => id}) do
    github_content = ContentCache.get_github_content!(id)
    changeset = ContentCache.change_github_content(github_content)
    render(conn, :edit, github_content: github_content, changeset: changeset)
  end

  def update(conn, %{"id" => id, "github_content" => github_content_params}) do
    github_content = ContentCache.get_github_content!(id)

    case ContentCache.update_github_content(github_content, github_content_params) do
      {:ok, github_content} ->
        conn
        |> put_flash(:info, "Git hub content updated successfully.")
        |> redirect(to: ~p"/github_cached_content/#{github_content}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, github_content: github_content, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    github_content = ContentCache.get_github_content!(id)
    {:ok, _github_content} = ContentCache.delete_github_content(github_content)

    conn
    |> put_flash(:info, "Git hub content deleted successfully.")
    |> redirect(to: ~p"/github_cached_content")
  end
end
