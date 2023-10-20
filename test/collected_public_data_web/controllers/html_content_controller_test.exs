defmodule CollectedPublicDataWeb.HTMLContentControllerTest do
  use CollectedPublicDataWeb.ConnCase

  import CollectedPublicData.ContentCacheFixtures

  @create_attrs %{size: 42, sha256: "some sha256", content: "some content"}
  @update_attrs %{size: 43, sha256: "some updated sha256", content: "some updated content"}
  @invalid_attrs %{size: nil, sha256: nil, content: nil}

  describe "index" do
    test "lists all html_cached_content", %{conn: conn} do
      conn = get(conn, ~p"/html")
      assert html_response(conn, 200) =~ "Listing Html cached content"
    end
  end

  describe "new html_content" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/html/new")
      assert html_response(conn, 200) =~ "New Html content"
    end
  end

  describe "create html_content" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/html", html_content: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/html/#{id}"

      conn = get(conn, ~p"/html/#{id}")
      assert html_response(conn, 200) =~ "Html content #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/html", html_content: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Html content"
    end
  end

  describe "edit html_content" do
    setup [:create_html_content]

    test "renders form for editing chosen html_content", %{conn: conn, html_content: html_content} do
      conn = get(conn, ~p"/html/#{html_content}/edit")
      assert html_response(conn, 200) =~ "Edit Html content"
    end
  end

  describe "update html_content" do
    setup [:create_html_content]

    test "redirects when data is valid", %{conn: conn, html_content: html_content} do
      conn = put(conn, ~p"/html/#{html_content}", html_content: @update_attrs)
      assert redirected_to(conn) == ~p"/html/#{html_content}"

      conn = get(conn, ~p"/html/#{html_content}")
      assert html_response(conn, 200) =~ "some updated sha256"
    end

    test "renders errors when data is invalid", %{conn: conn, html_content: html_content} do
      conn = put(conn, ~p"/html/#{html_content}", html_content: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Html content"
    end
  end

  describe "delete html_content" do
    setup [:create_html_content]

    test "deletes chosen html_content", %{conn: conn, html_content: html_content} do
      conn = delete(conn, ~p"/html/#{html_content}")
      assert redirected_to(conn) == ~p"/html"

      assert_error_sent 404, fn ->
        get(conn, ~p"/html/#{html_content}")
      end
    end
  end

  defp create_html_content(_) do
    html_content = html_content_fixture()
    %{html_content: html_content}
  end
end
