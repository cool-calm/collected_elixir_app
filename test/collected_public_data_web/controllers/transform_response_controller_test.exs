defmodule CollectedPublicDataWeb.TransformResponseControllerTest do
  use CollectedPublicDataWeb.ConnCase

  import CollectedPublicData.ContentTransformFixtures

  @create_attrs %{type_url: "some type_url", in_sha256: "some in_sha256", in_media_type: "some in_media_type", out_sha256: "some out_sha256", out_media_type: "some out_media_type"}
  @update_attrs %{type_url: "some updated type_url", in_sha256: "some updated in_sha256", in_media_type: "some updated in_media_type", out_sha256: "some updated out_sha256", out_media_type: "some updated out_media_type"}
  @invalid_attrs %{type_url: nil, in_sha256: nil, in_media_type: nil, out_sha256: nil, out_media_type: nil}

  describe "index" do
    test "lists all content_transform_response", %{conn: conn} do
      conn = get(conn, ~p"/content_transform_response")
      assert html_response(conn, 200) =~ "Listing Content transform response"
    end
  end

  describe "new transform_response" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/content_transform_response/new")
      assert html_response(conn, 200) =~ "New Transform response"
    end
  end

  describe "create transform_response" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/content_transform_response", transform_response: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/content_transform_response/#{id}"

      conn = get(conn, ~p"/content_transform_response/#{id}")
      assert html_response(conn, 200) =~ "Transform response #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/content_transform_response", transform_response: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Transform response"
    end
  end

  describe "edit transform_response" do
    setup [:create_transform_response]

    test "renders form for editing chosen transform_response", %{conn: conn, transform_response: transform_response} do
      conn = get(conn, ~p"/content_transform_response/#{transform_response}/edit")
      assert html_response(conn, 200) =~ "Edit Transform response"
    end
  end

  describe "update transform_response" do
    setup [:create_transform_response]

    test "redirects when data is valid", %{conn: conn, transform_response: transform_response} do
      conn = put(conn, ~p"/content_transform_response/#{transform_response}", transform_response: @update_attrs)
      assert redirected_to(conn) == ~p"/content_transform_response/#{transform_response}"

      conn = get(conn, ~p"/content_transform_response/#{transform_response}")
      assert html_response(conn, 200) =~ "some updated type_url"
    end

    test "renders errors when data is invalid", %{conn: conn, transform_response: transform_response} do
      conn = put(conn, ~p"/content_transform_response/#{transform_response}", transform_response: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Transform response"
    end
  end

  describe "delete transform_response" do
    setup [:create_transform_response]

    test "deletes chosen transform_response", %{conn: conn, transform_response: transform_response} do
      conn = delete(conn, ~p"/content_transform_response/#{transform_response}")
      assert redirected_to(conn) == ~p"/content_transform_response"

      assert_error_sent 404, fn ->
        get(conn, ~p"/content_transform_response/#{transform_response}")
      end
    end
  end

  defp create_transform_response(_) do
    transform_response = transform_response_fixture()
    %{transform_response: transform_response}
  end
end
