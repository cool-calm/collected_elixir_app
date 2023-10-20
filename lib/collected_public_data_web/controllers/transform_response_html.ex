defmodule CollectedPublicDataWeb.TransformResponseHTML do
  use CollectedPublicDataWeb, :html

  embed_templates "transform_response_html/*"

  @doc """
  Renders a transform_response form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def transform_response_form(assigns)
end
