defmodule ExCloudflareCalls.TURN do
  @moduledoc """
  Manages TURN Key Interactions.
  """
   alias ExCloudflareCore.API
  require Logger

  @spec create_turn_key(String.t(), String.t(), keyword) ::
      {:ok, map()} | {:error, String.t()}
  def create_turn_key(app_id, app_token, opts \\ []) do
    base_url = Keyword.get(opts, :base_url, "https://rtc.live.cloudflare.com")
    headers = [{'Authorization', "Bearer #{app_token}"}, {'Content-Type', 'application/json'}]
      body = %{ ttl: 86400 }

    API.request(:post, base_url, app_id, "/turn_keys", headers, body)
    |> case do
        {:ok, response} ->
          {:ok, response}
        {:error, reason} ->
          {:error, "Failed to create TURN key: #{reason}"}
        _ ->
          {:error, "Unexpected response"}
      end
  end

  @spec get_turn_key(String.t(), String.t(), String.t(), keyword) ::
    {:ok, map()} | {:error, String.t()}
 def get_turn_key(app_id, app_token, key_id, opts \\ []) do
    base_url = Keyword.get(opts, :base_url, "https://rtc.live.cloudflare.com")
   headers = [{'Authorization', "Bearer #{app_token}"}, {'Content-Type', 'application/json'}]

       API.request(:get, base_url, app_id, "/turn_keys/#{key_id}", headers)
     |> case do
        {:ok, response} ->
          {:ok, response}
        {:error, reason} ->
         {:error, "Failed to fetch TURN key details: #{reason}"}
        _ ->
          {:error, "Unexpected response"}
       end
  end


  @spec list_turn_keys(String.t(), String.t(), keyword) ::
     {:ok, map()} | {:error, String.t()}
 def list_turn_keys(app_id, app_token, opts \\ []) do
    base_url = Keyword.get(opts, :base_url, "https://rtc.live.cloudflare.com")
   headers = [{'Authorization', "Bearer #{app_token}"}, {'Content-Type', 'application/json'}]

       API.request(:get, base_url, app_id, "/turn_keys", headers)
  |> case do
       {:ok, response} ->
         {:ok, response}
        {:error, reason} ->
         {:error, "Failed to list TURN keys: #{reason}"}
       _ ->
          {:error, "Unexpected response"}
       end
  end


   @spec edit_turn_key(String.t(), String.t(), String.t(), keyword) ::
      {:ok, map()} | {:error, String.t()}
  def edit_turn_key(app_id, app_token, key_id, opts \\ []) do
       base_url = Keyword.get(opts, :base_url, "https://rtc.live.cloudflare.com")
    headers = [{'Authorization', "Bearer #{app_token}"}, {'Content-Type', 'application/json'}]
    body = %{ttl: 86400} # Add whatever is changeable later

       API.request(:put, base_url, app_id, "/turn_keys/#{key_id}",  headers, body)
   |> case do
       {:ok, response} ->
          {:ok, response}
       {:error, reason} ->
          {:error, "Failed to update TURN key: #{reason}"}
      _ ->
         {:error, "Unexpected response"}
    end
   end


   @spec delete_turn_key(String.t(), String.t(), String.t(), keyword) ::
       {:ok, map()} | {:error, String.t()}
   def delete_turn_key(app_id, app_token, key_id, opts \\ []) do
      base_url = Keyword.get(opts, :base_url, "https://rtc.live.cloudflare.com")
     headers = [{'Authorization', "Bearer #{app_token}"}, {'Content-Type', 'application/json'}]
       API.request(:delete, base_url, app_id, "/turn_keys/#{key_id}",  headers)
  |> case do
      {:ok, response} ->
           {:ok, response}
      {:error, reason} ->
           {:error, "Failed to delete TURN key: #{reason}"}
      _ ->
         {:error, "Unexpected response"}
    end
   end
end
