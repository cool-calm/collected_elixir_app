defmodule CollectedPublicDataWeb.MarkdownContentController do
  use CollectedPublicDataWeb, :controller

  alias CollectedPublicData.ContentCache
  alias CollectedPublicData.ContentCache.MarkdownContent
  alias CollectedPublicData.ContentTransform
  alias CollectedPublicData.ZipReader

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

  def create(conn, %{"github_repo_owner" => repo_owner, "github_repo_name" => repo_name}) do
    sha_url = URI.new!("https://collected.press/1/github/#{repo_owner}/#{repo_name}/refs/HEAD")
    %{body: %{"sha" => sha}} = Req.get!(sha_url)

    zip_url = "https://github.com/#{repo_owner}/#{repo_name}/archive/#{sha}.zip"
    %{body: zip_data} = Req.get!(zip_url, decode_body: false)

    zip = ZipReader.from_data(zip_data)
    # files = ZipReader.list_files(zip)
    markdown_files = ZipReader.filter_files(zip, %ZipReader.FileFilter{name_ending_with: ".md"})

    markdown_contents = for file <- markdown_files do
      case ZipReader.content_for_file(zip, file) do
        nil -> []
        string ->
          try do
            ContentCache.create_markdown_content(string)
          rescue
            _ ->
              nil
          end
      end
    end

    conn
        |> put_flash(:info, "Imported #{length(markdown_files)} Markdown files.")
        |> redirect(to: ~p"/markdown/new")

    # case ContentCache.create_markdown_content(markdown_content_params) do
    #   {:ok, markdown_content} ->
    #     conn
    #     |> put_flash(:info, "Markdown content created successfully.")
    #     |> redirect(to: ~p"/markdown/#{markdown_content}")

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, :new, changeset: changeset)
    # end
  end

  def show(conn, %{"id" => id}) do
    markdown_content = ContentCache.get_markdown_content!(id)

    outputs = ContentTransform.list_outputs_of("text/markdown", markdown_content.sha256)

    render(conn, :show, markdown_content: markdown_content, outputs: outputs)
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
