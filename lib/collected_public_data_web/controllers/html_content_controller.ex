defmodule CollectedPublicDataWeb.HTMLContentController do
  use CollectedPublicDataWeb, :controller

  alias CollectedPublicData.ContentCache
  alias CollectedPublicData.ContentCache.HTMLContent

  def index(conn, _params) do
    html_cached_content = ContentCache.list_html_cached_content()
    render(conn, :index, html_cached_content: html_cached_content)
  end

  def new(conn, _params) do
    changeset = ContentCache.change_html_content(%HTMLContent{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"html_content" => html_content_params}) do
    case ContentCache.create_html_content(html_content_params) do
      {:ok, html_content} ->
        conn
        |> put_flash(:info, "Html content created successfully.")
        |> redirect(to: ~p"/html/#{html_content}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    html_content = ContentCache.get_html_content!(id)
    render(conn, :show, html_content: html_content)
  end

  def edit(conn, %{"id" => id}) do
    html_content = ContentCache.get_html_content!(id)
    changeset = ContentCache.change_html_content(html_content)
    render(conn, :edit, html_content: html_content, changeset: changeset)
  end

  def update(conn, %{"id" => id, "html_content" => html_content_params}) do
    html_content = ContentCache.get_html_content!(id)

    case ContentCache.update_html_content(html_content, html_content_params) do
      {:ok, html_content} ->
        conn
        |> put_flash(:info, "Html content updated successfully.")
        |> redirect(to: ~p"/html/#{html_content}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, html_content: html_content, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    html_content = ContentCache.get_html_content!(id)
    {:ok, _html_content} = ContentCache.delete_html_content(html_content)

    conn
    |> put_flash(:info, "Html content deleted successfully.")
    |> redirect(to: ~p"/html")
  end
end
