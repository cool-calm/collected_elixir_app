defmodule CollectedPublicDataWeb.TransformResponseController do
  use CollectedPublicDataWeb, :controller

  alias CollectedPublicData.ContentTransform
  alias CollectedPublicData.ContentTransform.TransformResponse

  def index(conn, _params) do
    content_transform_response = ContentTransform.list_content_transform_response()
    render(conn, :index, content_transform_response: content_transform_response)
  end

  def new(conn, _params) do
    changeset = ContentTransform.change_transform_response(%TransformResponse{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"transform_response" => transform_response_params}) do
    case ContentTransform.create_transform_response(transform_response_params) do
      {:ok, transform_response} ->
        conn
        |> put_flash(:info, "Transform response created successfully.")
        |> redirect(to: ~p"/content_transform_response/#{transform_response}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    transform_response = ContentTransform.get_transform_response!(id)
    render(conn, :show, transform_response: transform_response)
  end

  def edit(conn, %{"id" => id}) do
    transform_response = ContentTransform.get_transform_response!(id)
    changeset = ContentTransform.change_transform_response(transform_response)
    render(conn, :edit, transform_response: transform_response, changeset: changeset)
  end

  def update(conn, %{"id" => id, "transform_response" => transform_response_params}) do
    transform_response = ContentTransform.get_transform_response!(id)

    case ContentTransform.update_transform_response(transform_response, transform_response_params) do
      {:ok, transform_response} ->
        conn
        |> put_flash(:info, "Transform response updated successfully.")
        |> redirect(to: ~p"/content_transform_response/#{transform_response}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, transform_response: transform_response, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    transform_response = ContentTransform.get_transform_response!(id)
    {:ok, _transform_response} = ContentTransform.delete_transform_response(transform_response)

    conn
    |> put_flash(:info, "Transform response deleted successfully.")
    |> redirect(to: ~p"/content_transform_response")
  end
end
