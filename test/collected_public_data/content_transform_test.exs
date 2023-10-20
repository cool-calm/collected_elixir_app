defmodule CollectedPublicData.ContentTransformTest do
  use CollectedPublicData.DataCase

  alias CollectedPublicData.ContentTransform

  describe "content_transform_response" do
    alias CollectedPublicData.ContentTransform.TransformResponse

    import CollectedPublicData.ContentTransformFixtures

    @invalid_attrs %{type_url: nil, in_sha256: nil, in_media_type: nil, out_sha256: nil, out_media_type: nil}

    test "list_content_transform_response/0 returns all content_transform_response" do
      transform_response = transform_response_fixture()
      assert ContentTransform.list_content_transform_response() == [transform_response]
    end

    test "get_transform_response!/1 returns the transform_response with given id" do
      transform_response = transform_response_fixture()
      assert ContentTransform.get_transform_response!(transform_response.id) == transform_response
    end

    test "create_transform_response/1 with valid data creates a transform_response" do
      valid_attrs = %{type_url: "some type_url", in_sha256: "some in_sha256", in_media_type: "some in_media_type", out_sha256: "some out_sha256", out_media_type: "some out_media_type"}

      assert {:ok, %TransformResponse{} = transform_response} = ContentTransform.create_transform_response(valid_attrs)
      assert transform_response.type_url == "some type_url"
      assert transform_response.in_sha256 == "some in_sha256"
      assert transform_response.in_media_type == "some in_media_type"
      assert transform_response.out_sha256 == "some out_sha256"
      assert transform_response.out_media_type == "some out_media_type"
    end

    test "create_transform_response/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ContentTransform.create_transform_response(@invalid_attrs)
    end

    test "update_transform_response/2 with valid data updates the transform_response" do
      transform_response = transform_response_fixture()
      update_attrs = %{type_url: "some updated type_url", in_sha256: "some updated in_sha256", in_media_type: "some updated in_media_type", out_sha256: "some updated out_sha256", out_media_type: "some updated out_media_type"}

      assert {:ok, %TransformResponse{} = transform_response} = ContentTransform.update_transform_response(transform_response, update_attrs)
      assert transform_response.type_url == "some updated type_url"
      assert transform_response.in_sha256 == "some updated in_sha256"
      assert transform_response.in_media_type == "some updated in_media_type"
      assert transform_response.out_sha256 == "some updated out_sha256"
      assert transform_response.out_media_type == "some updated out_media_type"
    end

    test "update_transform_response/2 with invalid data returns error changeset" do
      transform_response = transform_response_fixture()
      assert {:error, %Ecto.Changeset{}} = ContentTransform.update_transform_response(transform_response, @invalid_attrs)
      assert transform_response == ContentTransform.get_transform_response!(transform_response.id)
    end

    test "delete_transform_response/1 deletes the transform_response" do
      transform_response = transform_response_fixture()
      assert {:ok, %TransformResponse{}} = ContentTransform.delete_transform_response(transform_response)
      assert_raise Ecto.NoResultsError, fn -> ContentTransform.get_transform_response!(transform_response.id) end
    end

    test "change_transform_response/1 returns a transform_response changeset" do
      transform_response = transform_response_fixture()
      assert %Ecto.Changeset{} = ContentTransform.change_transform_response(transform_response)
    end
  end
end
