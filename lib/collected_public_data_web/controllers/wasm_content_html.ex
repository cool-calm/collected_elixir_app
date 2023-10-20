defmodule CollectedPublicDataWeb.WasmContentHTML do
  use CollectedPublicDataWeb, :html

  embed_templates "wasm_content_html/*"

  @doc """
  Renders a wasm_content form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def wasm_content_form(assigns)
end
