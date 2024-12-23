defmodule ExCloudflareCalls.SFU do
  @moduledoc """
  Manages Application interactions.
  """
   alias ExCloudflareCore.API
  require Logger

  @spec create_app(String.t(), String.t(), map(), keyword) ::
      {:ok, map()} | {:error, String.t()}
 def create_app(app_id, app_token, body, opts \\ []) do
   base_url = Keyword.get(opts, :base_url, "https://rtc.live.cloudflare.com")
   headers = [{'Authorization', "Bearer #{app_token}"}, {'Content-Type', 'application/json'}]

       API.request(:post, base_url, app_id, "/apps", headers, body)
    |> case do
        {:ok, response} ->
            {:ok, response}
        {:error, reason} ->
           {:error, "Failed to list apps: #{reason}"}
       _ ->
          {:error, "Unexpected response"}
    end
 end

   @spec get_app(String.t(), String.t(), keyword) ::
     {:ok, map()} | {:error, String.t()}
  def get_app(app_id, app_token, opts \\ []) do
   base_url = Keyword.get(opts, :base_url, "https://rtc.live.cloudflare.com")
   headers = [{'Authorization', "Bearer #{app_token}"}, {'Content-Type', 'application/json'}]

        API.request(:get, base_url, app_id, "/apps",  headers)
      |> case do
           {:ok, response} ->
             {:ok, response}
           {:error, reason} ->
              {:error, "Failed to list apps: #{reason}"}
          _ ->
              {:error, "Unexpected response"}
      end
 end

    @spec delete_app(String.t(), String.t(), keyword) ::
     {:ok, map()} | {:error, String.t()}
   def delete_app(app_id, app_token, opts \\ []) do
        base_url = Keyword.get(opts, :base_url, "https://rtc.live.cloudflare.com")
    headers = [{'Authorization', "Bearer #{app_token}"}, {'Content-Type', 'application/json'}]

      API.request(:delete, base_url, app_id, "/apps/#{app_id}", headers)
   |> case do
       {:ok, response} ->
            {:ok, response}
       {:error, reason} ->
           {:error, "Failed to delete app: #{reason}"}
        _ ->
           {:error, "Unexpected response"}
     end
   end

   @spec edit_app(String.t(), String.t(), String.t(), keyword) ::
     {:ok, map()} | {:error, String.t()}
   def edit_app(app_id, app_token, body, opts \\ []) do
        base_url = Keyword.get(opts, :base_url, "https://rtc.live.cloudflare.com")
     headers = [{'Authorization', "Bearer #{app_token}"}, {'Content-Type', 'application/json'}]
        API.request(:put, base_url, app_id, "/apps/#{app_id}", headers, body)
    |> case do
        {:ok, response} ->
           {:ok, response}
       {:error, reason} ->
          {:error, "Failed to edit app: #{reason}"}
         _ ->
           {:error, "Unexpected response"}
     end
   end

      @spec list_apps(String.t(), String.t(), keyword) ::
       {:ok, map()} | {:error, String.t()}
      def list_apps(app_id, app_token, opts \\ []) do
         base_url = Keyword.get(opts, :base_url, "https://rtc.live.cloudflare.com")
         headers = [{'Authorization', "Bearer #{app_token}"}, {'Content-Type', 'application/json'}]

         API.request(:get, base_url, app_id, "/apps",  headers)
        |> case do
            {:ok, response} ->
              {:ok, response}
          {:error, reason} ->
              {:error, "Failed to list apps: #{reason}"}
            _ ->
               {:error, "Unexpected response"}
       end
      end
end
