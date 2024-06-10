defmodule CollectedPublicDataWeb.AuthController do
  use CollectedPublicDataWeb, :controller

  def create(conn, _params) do
    state = Ecto.UUID.generate()
    conn = put_session(conn, "oauth2:state", state)
    redirect(conn, to: "?")
  end

  def show(conn, _params) do
    state = get_session(conn, "oauth2:state")

    if is_nil(state) do
      conn |> put_flash(:error, "GitHub state was not set in session.")
    else
      callback_uri =
        "/auth/callback/github"
        |> URI.parse()
        |> put_in([:scheme], conn.scheme)
        |> put_in([:host], conn.host)
        |> URI.new!()

      destination_url = URI.new!("https://github.com/login/oauth/authorize")

      destination_query =
        URI.encode_query(
          response_type: "code",
          client_id: "Iv1.fc660c6745417477",
          redirect_uri: URI.to_string(callback_uri),
          state: state,
          scope: "user:email"
        )

      destination_url = put_in(destination_url.query, destination_query)
      redirect(conn, external: URI.to_string(destination_url))
      # destination_url.searchParams.set('response_type', 'code');
      # destination_url.searchParams.set('client_id', process.env.GITHUB_CLIENT_ID!);
      # destination_url.searchParams.set('redirect_uri', callbackURL.toString());
      # destination_url.searchParams.set('state', state);
      # destination_url.searchParams.set('scope', 'user:email');
    end
  end
end

defmodule CollectedPublicDataWeb.AuthCallbackController do
  use CollectedPublicDataWeb, :controller

  def show(conn, _params) do
    state = get_session(conn, "oauth2:state")

    if is_nil(state) do
      conn |> put_flash(:error, "GitHub state was not set in session.")
    else
      callback_uri =
        "/auth/callback/github"
        |> URI.parse()
        |> put_in([:scheme], conn.scheme)
        |> put_in([:host], conn.host)
        |> URI.new!()

      destination_url = URI.new!("https://github.com/login/oauth/authorize")

      destination_query =
        URI.encode_query(
          response_type: "code",
          client_id: "Iv1.fc660c6745417477",
          redirect_uri: URI.to_string(callback_uri),
          state: state,
          scope: "user:email"
        )

      destination_url = put_in(destination_url.query, destination_query)
      redirect(conn, external: URI.to_string(destination_url))
      # destination_url.searchParams.set('response_type', 'code');
      # destination_url.searchParams.set('client_id', process.env.GITHUB_CLIENT_ID!);
      # destination_url.searchParams.set('redirect_uri', callbackURL.toString());
      # destination_url.searchParams.set('state', state);
      # destination_url.searchParams.set('scope', 'user:email');
    end
  end
end
