defmodule CollectedPublicDataWeb.GitHubContentControllerTest do
  use CollectedPublicDataWeb.ConnCase

  import CollectedPublicData.ContentCacheFixtures

  @create_attrs %{owner: "some owner", path: "some path", repo: "some repo", sha: "some sha", content: "some content", content_type: "some content_type"}
  @update_attrs %{owner: "some updated owner", path: "some updated path", repo: "some updated repo", sha: "some updated sha", content: "some updated content", content_type: "some updated content_type"}
  @invalid_attrs %{owner: nil, path: nil, repo: nil, sha: nil, content: nil, content_type: nil}

  describe "index" do
    test "lists all github_cached_content", %{conn: conn} do
      conn = get(conn, ~p"/github_cached_content")
      assert html_response(conn, 200) =~ "Listing Github cached content"
    end
  end

  describe "new github_content" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/github_cached_content/new")
      assert html_response(conn, 200) =~ "New GitHub content"
    end
  end

  describe "create github_content" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/github_cached_content", github_content: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/github_cached_content/#{id}"

      conn = get(conn, ~p"/github_cached_content/#{id}")
      assert html_response(conn, 200) =~ "Git hub content #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/github_cached_content", github_content: @invalid_attrs)
      assert html_response(conn, 200) =~ "New GitHub content"
    end
  end

  describe "edit github_content" do
    setup [:create_github_content]

    test "renders form for editing chosen github_content", %{conn: conn, github_content: github_content} do
      conn = get(conn, ~p"/github_cached_content/#{github_content}/edit")
      assert html_response(conn, 200) =~ "Edit Git hub content"
    end
  end

  describe "update github_content" do
    setup [:create_github_content]

    test "redirects when data is valid", %{conn: conn, github_content: github_content} do
      conn = put(conn, ~p"/github_cached_content/#{github_content}", github_content: @update_attrs)
      assert redirected_to(conn) == ~p"/github_cached_content/#{github_content}"

      conn = get(conn, ~p"/github_cached_content/#{github_content}")
      assert html_response(conn, 200) =~ "some updated owner"
    end

    test "renders errors when data is invalid", %{conn: conn, github_content: github_content} do
      conn = put(conn, ~p"/github_cached_content/#{github_content}", github_content: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Git hub content"
    end
  end

  describe "delete github_content" do
    setup [:create_github_content]

    test "deletes chosen github_content", %{conn: conn, github_content: github_content} do
      conn = delete(conn, ~p"/github_cached_content/#{github_content}")
      assert redirected_to(conn) == ~p"/github_cached_content"

      assert_error_sent 404, fn ->
        get(conn, ~p"/github_cached_content/#{github_content}")
      end
    end
  end

  defp create_github_content(_) do
    github_content = github_content_fixture()
    %{github_content: github_content}
  end
end
