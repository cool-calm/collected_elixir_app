defmodule CollectedPublicData.ZipReader do
  defmodule Item do
    defstruct name: ""

    def from_zip_file(
          {:zip_file, name,
           {:file_info, _size, _type, _access, _atime, _mtime, _ctime, _mode, _links, _, _, _, _,
            _}, _comment, _offset, _comp_size}
        ) do
      %__MODULE__{name: name}
    end
  end

  defstruct zip_data: nil

  # alias CollectedLive.Content.Archive.Item

  def from_data(data) when is_binary(data) do
    %__MODULE__{zip_data: data}
  end

  def list_files(%__MODULE__{zip_data: data}) do
    case :zip.list_dir(data) do
      {:ok, [_comment | zip_files]} -> zip_files
      _ -> nil
    end
  end

  defp include_name?(name, :contains, name_containing)
       when is_binary(name) and is_binary(name_containing) do
    if String.length(name_containing) > 2 do
      String.contains?(to_string(name), name_containing)
    else
      true
    end
  end

  defp include_name?(_name, :ends_with, ""), do: true

  defp include_name?(name, :ends_with, suffix) do
    String.ends_with?(to_string(name), suffix)
  end

  defp include_zip_file?(
         {:zip_file, name,
          {:file_info, _size, :regular, _access, _atime, _mtime, _ctime, _mode, _links, _, _, _,
           _, _}, _comment, _offset, _comp_size},
         name_containing
       )
       when is_binary(name_containing) do
    include_name?(to_string(name), :contains, name_containing)
  end

  defp include_zip_file?(
         {:zip_file, _, {:file_info, _, _, _, _, _, _, _, _, _, _, _, _, _}, _, _, _},
         name_containing
       )
       when is_binary(name_containing) do
    false
  end

  defmodule FileFilter do
    defstruct name_containing: "", name_ending_with: "", content_containing: ""
  end

  def filter_files(zip = %__MODULE__{}, %FileFilter{
        name_containing: name_containing,
        name_ending_with: name_ending_with,
        content_containing: content_containing
      }) do
    case String.trim(content_containing) do
      "" ->
        zip_files = list_files(zip)
        Enum.filter(zip_files, fn file -> include_zip_file?(file, name_containing) end)

      content_containing ->
        result =
          :zip.foldl(
            fn
              name_chars, get_info, get_binary, acc ->
                name = to_string(name_chars)

                with true <- include_name?(name, :contains, name_containing),
                     true <- include_name?(name, :ends_with, name_ending_with),
                     true <- String.contains?(get_binary.(), content_containing) do
                  file_info = get_info.()
                  fake_zip_file = {:zip_file, name_chars, file_info, "", 0, 0}
                  [fake_zip_file | acc]
                else
                  _ -> acc
                end
            end,
            [],
            {~c"name.zip", zip.zip_data}
          )

        case result do
          {:ok, files} -> files
          _ -> nil
        end
    end
  end

  def info_for_file_named(%__MODULE__{zip_data: data}, filename) do
    filename_chars = to_charlist(filename)

    result =
      :zip.foldl(
        fn
          ^filename_chars, get_info, _get_binary, _acc -> get_info.()
          _, _, _, acc -> acc
        end,
        nil,
        {~c"name.zip", data}
      )

    case result do
      {:ok, info} -> info
      _ -> nil
    end
  end

  def content_for_file_named(%__MODULE__{zip_data: data}, filename) do
    filename_chars = to_charlist(filename)

    result =
      :zip.foldl(
        fn
          ^filename_chars, _get_info, get_binary, _acc -> get_binary.()
          _, _, _, acc -> acc
        end,
        nil,
        {~c"name.zip", data}
      )

    case result do
      {:ok, content_data} -> content_data
      _ -> nil
    end
  end

  def content_for_file(
        %__MODULE__{zip_data: data},
        {:zip_file, name_chars, _file_info, _comment, _offset, _comp_size}
      ) do
    result =
      :zip.foldl(
        fn
          ^name_chars, _get_info, get_binary, _acc -> get_binary.()
          _, _, _, acc -> acc
        end,
        nil,
        {~c"name.zip", data}
      )

    case result do
      {:ok, content_data} -> content_data
      _ -> nil
    end
  end
end
