defmodule ExCloudflareCalls.Session do
  @moduledoc """
  Handles the creation and negotiation of Cloudflare Call Sessions
  """
    alias ExCloudflareCore.API
    alias ExCloudflareCalls.SDP
    require Logger


  @type session :: %{
    session_id: String.t()
  }

    @spec new_session(String.t(), String.t(), keyword) ::
            {:ok, session} | {:error, String.t()}
    def new_session(app_id, app_token, opts \\ []) do
        base_url = Keyword.get(opts, :base_url, "https://rtc.live.cloudflare.com")
        headers = [{'Authorization', "Bearer #{app_token}"}, {'Content-Type', 'application/json'}]
    API.request(:post, base_url, app_id, "/sessions/new", headers, opts)
    |> case do
        {:ok, %{"sessionId" => session_id}} ->
            {:ok, %{session_id: session_id}}
        {:error, reason} ->
            {:error, "Failed to create new session: #{reason}"}
        _ ->
            {:error, "Unexpected response"}
    end
    end

    @spec new_tracks(String.t(), String.t(), list(map()), keyword()) ::
        {:ok, map()} | {:error, String.t()}
    def new_tracks(session_id, app_id, tracks, opts \\ []) do
       base_url = Keyword.get(opts, :base_url, "https://rtc.live.cloudflare.com")
      token = Keyword.get(opts, :app_token)
            headers = [{'Authorization', "Bearer #{token}"}, {'Content-Type', 'application/json'}]
      case Keyword.get(opts, :session_description) do
        nil ->
            body = %{tracks: tracks}

            API.request(:post, base_url, app_id, "/sessions/#{session_id}/tracks/new", headers, body)
            |> case do
                {:ok, result} ->
                    {:ok, result}
                 {:error, reason} ->
                    {:error, "Failed to create new tracks: #{reason}"}
                 _ ->
                    {:error, "Unexpected response"}
            end
      {:ok, sdp} when is_map(sdp) ->
        body = %{tracks: tracks, sessionDescription: sdp}
        API.request(:post, base_url, app_id, "/sessions/#{session_id}/tracks/new", headers, body)
        |> case do
            {:ok, result} ->
              {:ok, result}
            {:error, reason} ->
                    {:error, "Failed to create new tracks: #{reason}"}
              _ ->
                    {:error, "Unexpected response"}
            end
        _ ->
            {:error, "Invalid session description passed, expected type map"}
        end
    end

    @spec renegotiate(String.t(), String.t(), String.t(), String.t(), keyword()) ::
        {:ok, map()} | {:error, String.t()}
    def renegotiate(session_id, app_id, sdp, type, opts \\ []) do
       base_url = Keyword.get(opts, :base_url, "https://rtc.live.cloudflare.com")
         token = Keyword.get(opts, :app_token)
         headers = [{'Authorization', "Bearer #{token}"}, {'Content-Type', 'application/json'}]
      body = %{sessionDescription: %{type: type, sdp: sdp}}
            API.request(:put, base_url, app_id, "/sessions/#{session_id}/renegotiate", headers, body)
    |> case do
          {:ok, result} ->
            {:ok, result}
          {:error, reason} ->
            {:error, "Failed to renegotiate the session: #{reason}"}
          _ ->
           {:error, "Unexpected response"}
        end
    end

  @spec close_track(String.t(), String.t(), list(map()), keyword()) ::
    {:ok, map()} | {:error, String.t()}
  def close_track(session_id, app_id, tracks, opts \\ []) do
      base_url = Keyword.get(opts, :base_url, "https://rtc.live.cloudflare.com")
        token = Keyword.get(opts, :app_token)
        headers = [{'Authorization', "Bearer #{token}"}, {'Content-Type', 'application/json'}]
    body = %{tracks: tracks, force: true}
        API.request(:put, base_url, app_id, "/sessions/#{session_id}/tracks/close", headers, body)
    |> case do
            {:ok, result} ->
              {:ok, result}
            {:error, reason} ->
              {:error, "Failed to close the track: #{reason}"}
            _ ->
              {:error, "Unexpected response"}
        end
  end
end
