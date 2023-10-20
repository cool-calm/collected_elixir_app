defmodule CollectedPublicDataWeb.MarkdownContentControllerTest do
  use CollectedPublicDataWeb.ConnCase

  import CollectedPublicData.ContentCacheFixtures

  @create_attrs %{size: 42, sha256: "some sha256", content: "some content"}
  @update_attrs %{size: 43, sha256: "some updated sha256", content: "some updated content"}
  @invalid_attrs %{size: nil, sha256: nil, content: nil}

  describe "index" do
    test "lists all markdown_cached_content", %{conn: conn} do
      conn = get(conn, ~p"/markdown_cached_content")
      assert html_response(conn, 200) =~ "Listing Markdown cached content"
    end
  end

  describe "new markdown_content" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/markdown_cached_content/new")
      assert html_response(conn, 200) =~ "New Markdown content"
    end
  end

  describe "create markdown_content" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/markdown_cached_content", markdown_content: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/markdown_cached_content/#{id}"

      conn = get(conn, ~p"/markdown_cached_content/#{id}")
      assert html_response(conn, 200) =~ "Markdown content #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/markdown_cached_content", markdown_content: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Markdown content"
    end
  end

  describe "edit markdown_content" do
    setup [:create_markdown_content]

    test "renders form for editing chosen markdown_content", %{conn: conn, markdown_content: markdown_content} do
      conn = get(conn, ~p"/markdown_cached_content/#{markdown_content}/edit")
      assert html_response(conn, 200) =~ "Edit Markdown content"
    end
  end

  describe "update markdown_content" do
    setup [:create_markdown_content]

    test "redirects when data is valid", %{conn: conn, markdown_content: markdown_content} do
      conn = put(conn, ~p"/markdown_cached_content/#{markdown_content}", markdown_content: @update_attrs)
      assert redirected_to(conn) == ~p"/markdown_cached_content/#{markdown_content}"

      conn = get(conn, ~p"/markdown_cached_content/#{markdown_content}")
      assert html_response(conn, 200) =~ "some updated sha256"
    end

    test "renders errors when data is invalid", %{conn: conn, markdown_content: markdown_content} do
      conn = put(conn, ~p"/markdown_cached_content/#{markdown_content}", markdown_content: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Markdown content"
    end
  end

  describe "delete markdown_content" do
    setup [:create_markdown_content]

    test "deletes chosen markdown_content", %{conn: conn, markdown_content: markdown_content} do
      conn = delete(conn, ~p"/markdown_cached_content/#{markdown_content}")
      assert redirected_to(conn) == ~p"/markdown_cached_content"

      assert_error_sent 404, fn ->
        get(conn, ~p"/markdown_cached_content/#{markdown_content}")
      end
    end
  end

  defp create_markdown_content(_) do
    markdown_content = markdown_content_fixture()
    %{markdown_content: markdown_content}
  end
end
