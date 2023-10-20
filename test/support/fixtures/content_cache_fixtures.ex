defmodule CollectedPublicData.ContentCacheFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CollectedPublicData.ContentCache` context.
  """

  @doc """
  Generate a github_content.
  """
  def github_content_fixture(attrs \\ %{}) do
    {:ok, github_content} =
      attrs
      |> Enum.into(%{
        content: "some content",
        content_type: "some content_type",
        owner: "some owner",
        path: "some path",
        repo: "some repo",
        sha: "some sha"
      })
      |> CollectedPublicData.ContentCache.create_github_content()

    github_content
  end

  @doc """
  Generate a wasm_content.
  """
  def wasm_content_fixture(attrs \\ %{}) do
    {:ok, wasm_content} =
      attrs
      |> Enum.into(%{
        content: "some content",
        sha256: "some sha256"
      })
      |> CollectedPublicData.ContentCache.create_wasm_content()

    wasm_content
  end

  @doc """
  Generate a markdown_content.
  """
  def markdown_content_fixture(attrs \\ %{}) do
    {:ok, markdown_content} =
      attrs
      |> Enum.into(%{
        content: "some content",
        sha256: "some sha256",
        size: 42
      })
      |> CollectedPublicData.ContentCache.create_markdown_content()

    markdown_content
  end
end
