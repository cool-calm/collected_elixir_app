defmodule CollectedPublicDataWeb.MarkdownContentHTML do
  use CollectedPublicDataWeb, :html

  embed_templates "markdown_content_html/*"

  @doc """
  Renders a markdown_content form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def markdown_content_form(assigns)
end
