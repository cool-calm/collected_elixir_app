defmodule CollectedPublicDataWeb.WasmContentController do
  use CollectedPublicDataWeb, :controller

  alias CollectedPublicData.ContentCache
  alias CollectedPublicData.ContentCache.WasmContent

  def index(conn, _params) do
    wasm_cached_content = ContentCache.list_wasm_cached_content()
    render(conn, :index, wasm_cached_content: wasm_cached_content)
  end

  def new(conn, _params) do
    changeset = ContentCache.change_wasm_content(%WasmContent{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"wasm_content" => wasm_content_params}) do
    case ContentCache.create_wasm_content(wasm_content_params) do
      {:ok, wasm_content} ->
        conn
        |> put_flash(:info, "Wasm content created successfully.")
        |> redirect(to: ~p"/wasm_cached_content/#{wasm_content}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    wasm_content = ContentCache.get_wasm_content!(id)
    render(conn, :show, wasm_content: wasm_content)
  end

  def edit(conn, %{"id" => id}) do
    wasm_content = ContentCache.get_wasm_content!(id)
    changeset = ContentCache.change_wasm_content(wasm_content)
    render(conn, :edit, wasm_content: wasm_content, changeset: changeset)
  end

  # def update(conn, %{"id" => id, "wasm_content" => wasm_content_params}) do
  #   wasm_content = ContentCache.get_wasm_content!(id)

  #   case ContentCache.update_wasm_content(wasm_content, wasm_content_params) do
  #     {:ok, wasm_content} ->
  #       conn
  #       |> put_flash(:info, "Wasm content updated successfully.")
  #       |> redirect(to: ~p"/wasm_cached_content/#{wasm_content}")

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, :edit, wasm_content: wasm_content, changeset: changeset)
  #   end
  # end

  def delete(conn, %{"id" => id}) do
    wasm_content = ContentCache.get_wasm_content!(id)
    {:ok, _wasm_content} = ContentCache.delete_wasm_content(wasm_content)

    conn
    |> put_flash(:info, "Wasm content deleted successfully.")
    |> redirect(to: ~p"/wasm_cached_content")
  end
end
