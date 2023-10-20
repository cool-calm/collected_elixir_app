defmodule CollectedPublicDataWeb.HTMLContentHTML do
  use CollectedPublicDataWeb, :html

  embed_templates "html_content_html/*"

  @doc """
  Renders a html_content form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def html_content_form(assigns)
end
