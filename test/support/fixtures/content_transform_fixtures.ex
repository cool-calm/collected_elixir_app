defmodule CollectedPublicData.ContentTransformFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CollectedPublicData.ContentTransform` context.
  """

  @doc """
  Generate a transform_response.
  """
  def transform_response_fixture(attrs \\ %{}) do
    {:ok, transform_response} =
      attrs
      |> Enum.into(%{
        in_media_type: "some in_media_type",
        in_sha256: "some in_sha256",
        out_media_type: "some out_media_type",
        out_sha256: "some out_sha256",
        type_url: "some type_url"
      })
      |> CollectedPublicData.ContentTransform.create_transform_response()

    transform_response
  end
end
