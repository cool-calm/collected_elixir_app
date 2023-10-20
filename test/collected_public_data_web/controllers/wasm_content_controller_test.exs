defmodule CollectedPublicDataWeb.WasmContentControllerTest do
  use CollectedPublicDataWeb.ConnCase

  import CollectedPublicData.ContentCacheFixtures

  @create_attrs %{sha256: "some sha256", content: "some content"}
  @update_attrs %{sha256: "some updated sha256", content: "some updated content"}
  @invalid_attrs %{sha256: nil, content: nil}

  describe "index" do
    test "lists all wasm_cached_content", %{conn: conn} do
      conn = get(conn, ~p"/wasm")
      assert html_response(conn, 200) =~ "Listing Wasm cached content"
    end
  end

  describe "new wasm_content" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/wasm/new")
      assert html_response(conn, 200) =~ "New Wasm content"
    end
  end

  describe "create wasm_content" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/wasm", wasm_content: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/wasm/#{id}"

      conn = get(conn, ~p"/wasm/#{id}")
      assert html_response(conn, 200) =~ "Wasm content #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/wasm", wasm_content: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Wasm content"
    end
  end

  describe "edit wasm_content" do
    setup [:create_wasm_content]

    test "renders form for editing chosen wasm_content", %{conn: conn, wasm_content: wasm_content} do
      conn = get(conn, ~p"/wasm/#{wasm_content}/edit")
      assert html_response(conn, 200) =~ "Edit Wasm content"
    end
  end

  describe "update wasm_content" do
    setup [:create_wasm_content]

    test "redirects when data is valid", %{conn: conn, wasm_content: wasm_content} do
      conn = put(conn, ~p"/wasm/#{wasm_content}", wasm_content: @update_attrs)
      assert redirected_to(conn) == ~p"/wasm/#{wasm_content}"

      conn = get(conn, ~p"/wasm/#{wasm_content}")
      assert html_response(conn, 200) =~ "some updated sha256"
    end

    test "renders errors when data is invalid", %{conn: conn, wasm_content: wasm_content} do
      conn = put(conn, ~p"/wasm/#{wasm_content}", wasm_content: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Wasm content"
    end
  end

  describe "delete wasm_content" do
    setup [:create_wasm_content]

    test "deletes chosen wasm_content", %{conn: conn, wasm_content: wasm_content} do
      conn = delete(conn, ~p"/wasm/#{wasm_content}")
      assert redirected_to(conn) == ~p"/wasm"

      assert_error_sent 404, fn ->
        get(conn, ~p"/wasm/#{wasm_content}")
      end
    end
  end

  defp create_wasm_content(_) do
    wasm_content = wasm_content_fixture()
    %{wasm_content: wasm_content}
  end
end
