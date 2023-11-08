# Also see https://github.com/phoenixframework/phoenix/blob/4da71906da970a162c88e165cdd2fdfaf9083ac3/test/support/websocket_client.exs

defmodule CollectedPressWs do
  use GenServer

  require Logger
  require Mint.HTTP

  defstruct [
    :uri,
    :conn,
    :websocket,
    :request_ref,
    :caller,
    :status,
    :resp_headers,
    :closing?,
    :callers_to_rpc_ids
  ]

  @name __MODULE__

  # GenServer.call(CollectedPressWs, {:send_text, Jason.encode!(%{"id": 2, "method": "markdown", "params": %{source: "# Hello"}})})

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: @name)
  end

  def connect(url) do
    with {:ok, socket} <- GenServer.start_link(__MODULE__, []),
         {:ok, :connected} <- GenServer.call(socket, {:connect, url}) do
      {:ok, socket}
    end
  end

  @spec send_message(atom() | pid() | {atom(), any()} | {:via, atom(), any()}, any()) :: any()
  def send_message(pid, text) do
    GenServer.call(pid, {:send_text, text})
  end

  @impl GenServer
  def init(url: url) do
    uri = URI.parse(url)
    # {:ok, %__MODULE__{uri: uri}}

    state = %__MODULE__{uri: uri, callers_to_rpc_ids: %{}}
    {:ok, state, {:continue, {:connect, url}}}
  end

  @impl GenServer
  def handle_continue({:connect, _url}, state) do
    uri = state.uri

    http_scheme =
      case uri.scheme do
        "ws" -> :http
        "wss" -> :https
      end

    ws_scheme =
      case uri.scheme do
        "ws" -> :ws
        "wss" -> :wss
      end

    path =
      case uri.query do
        nil -> uri.path
        query -> uri.path <> "?" <> query
      end

    with {:ok, conn} <- Mint.HTTP.connect(http_scheme, uri.host, uri.port, protocols: [:http1]),
         {:ok, conn, ref} <- Mint.WebSocket.upgrade(ws_scheme, conn, path, []) do
      state = %{state | conn: conn, request_ref: ref}
      {:noreply, state}
    else
      {:error, reason} ->
        {:stop, {:error, reason}, state}

      {:error, conn, reason} ->
        {:stop, {:error, reason}, put_in(state.conn, conn)}
    end
  end

  @impl GenServer
  def handle_call({:send_text, text}, _from, state) do
    {:ok, state} = send_frame(state, {:text, text})
    {:reply, :ok, state}
  end

  @impl GenServer
  def handle_call({:markdown_to_html, markdown_text}, from, state) do
    rpc_id = Ecto.UUID.generate()
    json = Jason.encode!(%{id: rpc_id, method: "markdown", params: %{source: markdown_text}})
    state = add_caller_rpc_id(state, from, rpc_id)
    {:ok, state} = send_frame(state, {:text, json})
    {:noreply, state}
  end

  @impl GenServer
  def handle_call({:connect, url}, from, state) do
    uri = URI.parse(url)

    http_scheme =
      case uri.scheme do
        "ws" -> :http
        "wss" -> :https
      end

    ws_scheme =
      case uri.scheme do
        "ws" -> :ws
        "wss" -> :wss
      end

    path =
      case uri.query do
        nil -> uri.path
        query -> uri.path <> "?" <> query
      end

    with {:ok, conn} <- Mint.HTTP.connect(http_scheme, uri.host, uri.port, protocols: [:http1]),
         {:ok, conn, ref} <- Mint.WebSocket.upgrade(ws_scheme, conn, path, []) do
      state = %{state | conn: conn, request_ref: ref, caller: from}
      {:noreply, state}
    else
      {:error, reason} ->
        {:reply, {:error, reason}, state}

      {:error, conn, reason} ->
        {:reply, {:error, reason}, put_in(state.conn, conn)}
    end
  end

  @impl GenServer
  def handle_info(message, state) do
    case Mint.WebSocket.stream(state.conn, message) do
      {:ok, conn, responses} ->
        state = put_in(state.conn, conn) |> handle_responses(responses)
        if state.closing?, do: do_close(state), else: {:noreply, state}

      {:error, conn, reason, _responses} ->
        state = put_in(state.conn, conn) |> reply({:error, reason})
        {:noreply, state}

      :unknown ->
        {:noreply, state}
    end
  end

  defp handle_responses(state, responses)

  defp handle_responses(%{request_ref: ref} = state, [{:status, ref, status} | rest]) do
    put_in(state.status, status)
    |> handle_responses(rest)
  end

  defp handle_responses(%{request_ref: ref} = state, [{:headers, ref, resp_headers} | rest]) do
    put_in(state.resp_headers, resp_headers)
    |> handle_responses(rest)
  end

  defp handle_responses(%{request_ref: ref} = state, [{:done, ref} | rest]) do
    case Mint.WebSocket.new(state.conn, ref, state.status, state.resp_headers) do
      {:ok, conn, websocket} ->
        %{state | conn: conn, websocket: websocket, status: nil, resp_headers: nil}
        |> reply({:ok, :connected})
        |> handle_responses(rest)

      {:error, conn, reason} ->
        put_in(state.conn, conn)
        |> reply({:error, reason})
    end
  end

  defp handle_responses(%{request_ref: ref, websocket: websocket} = state, [
         {:data, ref, data} | rest
       ])
       when websocket != nil do
    case Mint.WebSocket.decode(websocket, data) do
      {:ok, websocket, frames} ->
        put_in(state.websocket, websocket)
        |> handle_frames(frames)
        |> handle_responses(rest)

      {:error, websocket, reason} ->
        put_in(state.websocket, websocket)
        |> reply({:error, reason})
    end
  end

  defp handle_responses(state, [_response | rest]) do
    handle_responses(state, rest)
  end

  defp handle_responses(state, []), do: state

  defp send_frame(state, frame) do
    with {:ok, websocket, data} <- Mint.WebSocket.encode(state.websocket, frame),
         state = put_in(state.websocket, websocket),
         {:ok, conn} <- Mint.WebSocket.stream_request_body(state.conn, state.request_ref, data) do
      {:ok, put_in(state.conn, conn)}
    else
      {:error, %Mint.WebSocket{} = websocket, reason} ->
        IO.puts("CollectedPressWs error Mint.WebSocket.encode")
        {:error, put_in(state.websocket, websocket), reason}

      {:error, conn, reason} ->
        IO.puts("CollectedPressWs error Mint.WebSocket.stream_request_body")
        {:error, put_in(state.conn, conn), reason}
    end
  end

  def handle_frames(state, frames) do
    Enum.reduce(frames, state, fn
      # reply to pings with pongs
      {:ping, data}, state ->
        {:ok, state} = send_frame(state, {:pong, data})
        state

      {:close, _code, reason}, state ->
        Logger.debug("Closing connection: #{inspect(reason)}")
        %{state | closing?: true}

      {:text, text}, state ->
        # Logger.debug("Received: #{inspect(text)}, sending back the reverse")
        # {:ok, state} = send_frame(state, {:text, String.reverse(text)})
        Logger.debug("Received: #{inspect(text)}")

        case Jason.decode(text) do
          {:ok, %{"jsonrpc" => "2.0", "id" => rpc_id, "result" => result}} ->
            Logger.debug("Received: #{rpc_id} #{inspect(result)}")

            case pop_caller_rpc_id(state, rpc_id) do
              {nil, state} ->
                # Ignore
                state

              {caller, state} ->
                GenServer.reply(caller, result["html"])
                state
            end

          _ ->
            state
        end

      frame, state ->
        Logger.debug("Unexpected frame received: #{inspect(frame)}")
        state
    end)
  end

  defp do_close(state) do
    # Streaming a close frame may fail if the server has already closed
    # for writing.
    _ = send_frame(state, :close)
    Mint.HTTP.close(state.conn)
    {:stop, :normal, state}
  end

  defp reply(state, response) do
    if state.caller, do: GenServer.reply(state.caller, response)
    put_in(state.caller, nil)
  end

  defp add_caller_rpc_id(state, caller, rpc_id) do
    put_in(state.callers_to_rpc_ids[rpc_id], caller)
  end

  defp pop_caller_rpc_id(state, rpc_id) do
    pop_in(state.callers_to_rpc_ids[rpc_id])
  end

  def markdown_to_html(markdown_text) do
    GenServer.call(@name, {:markdown_to_html, markdown_text})
  end
end

# {:ok, pid} = Ws.connect("ws://localhost:1234/")
# Ws.send_message(pid, "Hello from WS client")
