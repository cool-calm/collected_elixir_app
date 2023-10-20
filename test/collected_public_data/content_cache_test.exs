defmodule CollectedPublicData.ContentCacheTest do
  use CollectedPublicData.DataCase

  alias CollectedPublicData.ContentCache

  describe "github_cached_content" do
    alias CollectedPublicData.ContentCache.GitHubContent

    import CollectedPublicData.ContentCacheFixtures

    @invalid_attrs %{owner: nil, path: nil, repo: nil, sha: nil, content: nil, content_type: nil}

    test "list_github_cached_content/0 returns all github_cached_content" do
      github_content = github_content_fixture()
      assert ContentCache.list_github_cached_content() == [github_content]
    end

    test "get_github_content!/1 returns the github_content with given id" do
      github_content = github_content_fixture()
      assert ContentCache.get_github_content!(github_content.id) == github_content
    end

    test "create_github_content/1 with valid data creates a github_content" do
      valid_attrs = %{owner: "some owner", path: "some path", repo: "some repo", sha: "some sha", content: "some content", content_type: "some content_type"}

      assert {:ok, %GitHubContent{} = github_content} = ContentCache.create_github_content(valid_attrs)
      assert github_content.owner == "some owner"
      assert github_content.path == "some path"
      assert github_content.repo == "some repo"
      assert github_content.sha == "some sha"
      assert github_content.content == "some content"
      assert github_content.content_type == "some content_type"
    end

    test "create_github_content/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ContentCache.create_github_content(@invalid_attrs)
    end

    test "update_github_content/2 with valid data updates the github_content" do
      github_content = github_content_fixture()
      update_attrs = %{owner: "some updated owner", path: "some updated path", repo: "some updated repo", sha: "some updated sha", content: "some updated content", content_type: "some updated content_type"}

      assert {:ok, %GitHubContent{} = github_content} = ContentCache.update_github_content(github_content, update_attrs)
      assert github_content.owner == "some updated owner"
      assert github_content.path == "some updated path"
      assert github_content.repo == "some updated repo"
      assert github_content.sha == "some updated sha"
      assert github_content.content == "some updated content"
      assert github_content.content_type == "some updated content_type"
    end

    test "update_github_content/2 with invalid data returns error changeset" do
      github_content = github_content_fixture()
      assert {:error, %Ecto.Changeset{}} = ContentCache.update_github_content(github_content, @invalid_attrs)
      assert github_content == ContentCache.get_github_content!(github_content.id)
    end

    test "delete_github_content/1 deletes the github_content" do
      github_content = github_content_fixture()
      assert {:ok, %GitHubContent{}} = ContentCache.delete_github_content(github_content)
      assert_raise Ecto.NoResultsError, fn -> ContentCache.get_github_content!(github_content.id) end
    end

    test "change_github_content/1 returns a github_content changeset" do
      github_content = github_content_fixture()
      assert %Ecto.Changeset{} = ContentCache.change_github_content(github_content)
    end
  end

  describe "wasm_cached_content" do
    alias CollectedPublicData.ContentCache.WasmContent

    import CollectedPublicData.ContentCacheFixtures

    @invalid_attrs %{sha256: nil, content: nil}

    test "list_wasm_cached_content/0 returns all wasm_cached_content" do
      wasm_content = wasm_content_fixture()
      assert ContentCache.list_wasm_cached_content() == [wasm_content]
    end

    test "get_wasm_content!/1 returns the wasm_content with given id" do
      wasm_content = wasm_content_fixture()
      assert ContentCache.get_wasm_content!(wasm_content.id) == wasm_content
    end

    test "create_wasm_content/1 with valid data creates a wasm_content" do
      valid_attrs = %{sha256: "some sha256", content: "some content"}

      assert {:ok, %WasmContent{} = wasm_content} = ContentCache.create_wasm_content(valid_attrs)
      assert wasm_content.sha256 == "some sha256"
      assert wasm_content.content == "some content"
    end

    test "create_wasm_content/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ContentCache.create_wasm_content(@invalid_attrs)
    end

    test "update_wasm_content/2 with valid data updates the wasm_content" do
      wasm_content = wasm_content_fixture()
      update_attrs = %{sha256: "some updated sha256", content: "some updated content"}

      assert {:ok, %WasmContent{} = wasm_content} = ContentCache.update_wasm_content(wasm_content, update_attrs)
      assert wasm_content.sha256 == "some updated sha256"
      assert wasm_content.content == "some updated content"
    end

    test "update_wasm_content/2 with invalid data returns error changeset" do
      wasm_content = wasm_content_fixture()
      assert {:error, %Ecto.Changeset{}} = ContentCache.update_wasm_content(wasm_content, @invalid_attrs)
      assert wasm_content == ContentCache.get_wasm_content!(wasm_content.id)
    end

    test "delete_wasm_content/1 deletes the wasm_content" do
      wasm_content = wasm_content_fixture()
      assert {:ok, %WasmContent{}} = ContentCache.delete_wasm_content(wasm_content)
      assert_raise Ecto.NoResultsError, fn -> ContentCache.get_wasm_content!(wasm_content.id) end
    end

    test "change_wasm_content/1 returns a wasm_content changeset" do
      wasm_content = wasm_content_fixture()
      assert %Ecto.Changeset{} = ContentCache.change_wasm_content(wasm_content)
    end
  end

  describe "markdown_cached_content" do
    alias CollectedPublicData.ContentCache.MarkdownContent

    import CollectedPublicData.ContentCacheFixtures

    @invalid_attrs %{size: nil, sha256: nil, content: nil}

    test "list_markdown_cached_content/0 returns all markdown_cached_content" do
      markdown_content = markdown_content_fixture()
      assert ContentCache.list_markdown_cached_content() == [markdown_content]
    end

    test "get_markdown_content!/1 returns the markdown_content with given id" do
      markdown_content = markdown_content_fixture()
      assert ContentCache.get_markdown_content!(markdown_content.id) == markdown_content
    end

    test "create_markdown_content/1 with valid data creates a markdown_content" do
      valid_attrs = %{size: 42, sha256: "some sha256", content: "some content"}

      assert {:ok, %MarkdownContent{} = markdown_content} = ContentCache.create_markdown_content(valid_attrs)
      assert markdown_content.size == 42
      assert markdown_content.sha256 == "some sha256"
      assert markdown_content.content == "some content"
    end

    test "create_markdown_content/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ContentCache.create_markdown_content(@invalid_attrs)
    end

    test "update_markdown_content/2 with valid data updates the markdown_content" do
      markdown_content = markdown_content_fixture()
      update_attrs = %{size: 43, sha256: "some updated sha256", content: "some updated content"}

      assert {:ok, %MarkdownContent{} = markdown_content} = ContentCache.update_markdown_content(markdown_content, update_attrs)
      assert markdown_content.size == 43
      assert markdown_content.sha256 == "some updated sha256"
      assert markdown_content.content == "some updated content"
    end

    test "update_markdown_content/2 with invalid data returns error changeset" do
      markdown_content = markdown_content_fixture()
      assert {:error, %Ecto.Changeset{}} = ContentCache.update_markdown_content(markdown_content, @invalid_attrs)
      assert markdown_content == ContentCache.get_markdown_content!(markdown_content.id)
    end

    test "delete_markdown_content/1 deletes the markdown_content" do
      markdown_content = markdown_content_fixture()
      assert {:ok, %MarkdownContent{}} = ContentCache.delete_markdown_content(markdown_content)
      assert_raise Ecto.NoResultsError, fn -> ContentCache.get_markdown_content!(markdown_content.id) end
    end

    test "change_markdown_content/1 returns a markdown_content changeset" do
      markdown_content = markdown_content_fixture()
      assert %Ecto.Changeset{} = ContentCache.change_markdown_content(markdown_content)
    end
  end
end
