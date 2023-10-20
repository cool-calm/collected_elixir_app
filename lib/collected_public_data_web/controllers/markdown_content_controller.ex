defmodule CollectedPublicDataWeb.MarkdownContentController do
  use CollectedPublicDataWeb, :controller

  alias CollectedPublicData.ContentTransform
  alias CollectedPublicData.ContentCache
  alias CollectedPublicData.ContentCache.MarkdownContent

  def index(conn, _params) do
    markdown_cached_content = ContentCache.list_markdown_cached_content()
    render(conn, :index, markdown_cached_content: markdown_cached_content)
  end

  def new(conn, _params) do
    changeset = ContentCache.change_markdown_content(%MarkdownContent{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"markdown_content" => markdown_content_params}) do
    case ContentCache.create_markdown_content(markdown_content_params) do
      {:ok, markdown_content} ->
        conn
        |> put_flash(:info, "Markdown content created successfully.")
        |> redirect(to: ~p"/markdown/#{markdown_content}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    markdown_content = ContentCache.get_markdown_content!(id)
    render(conn, :show, markdown_content: markdown_content)
  end

  def edit(conn, %{"id" => id}) do
    markdown_content = ContentCache.get_markdown_content!(id)
    changeset = ContentCache.change_markdown_content(markdown_content)
    render(conn, :edit, markdown_content: markdown_content, changeset: changeset)
  end

  def update(conn, %{"id" => id, "markdown_content" => markdown_content_params}) do
    markdown_content = ContentCache.get_markdown_content!(id)

    case ContentCache.update_markdown_content(markdown_content, markdown_content_params) do
      {:ok, markdown_content} ->
        conn
        |> put_flash(:info, "Markdown content updated successfully.")
        |> redirect(to: ~p"/markdown/#{markdown_content}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, markdown_content: markdown_content, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    markdown_content = ContentCache.get_markdown_content!(id)
    {:ok, _markdown_content} = ContentCache.delete_markdown_content(markdown_content)

    conn
    |> put_flash(:info, "Markdown content deleted successfully.")
    |> redirect(to: ~p"/markdown")
  end

  def transform_html(conn, %{"markdown_content_id" => id}) do
    markdown_content = ContentCache.get_markdown_content!(id)
    html_content = ContentTransform.render_markdown(markdown_content.sha256)

    conn
    |> redirect(to: ~p"/html/#{html_content}")
  end
end
