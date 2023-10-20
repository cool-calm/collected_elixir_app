defmodule CollectedPublicDataWeb.GitHubContentHTML do
  use CollectedPublicDataWeb, :html

  embed_templates "github_content_html/*"

  @doc """
  Renders a github_content form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def github_content_form(assigns)
end
