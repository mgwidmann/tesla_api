defmodule TeslaApi do
  @moduledoc """
  Tesla Model 3/S/X Vehicle API

  Implemented based upon documentation hosted at https://tesla-api.timdorr.com/
  """

  @doc false
  @spec request(:get | :post, Tesla.url(), list() | map() | nil) :: {:ok | :error, Tesla.Env.t()}
  def request(method, url, token, params \\ [])

  def request(:get, url, token, _params) do
    token
    |> client()
    |> Tesla.get(url)
  end

  def request(:post, url, token, params) when is_list(params) or is_map(params) do
    token
    |> client()
    |> Tesla.post(url, params)
  end

  @adapter {Tesla.Adapter.Hackney, [recv_timeout: 30_000]}
  @spec client(String.t()) :: Tesla.Client.t()
  defp client(token) do
    middleware =
      [
        {Tesla.Middleware.BaseUrl, "https://owner-api.teslamotors.com/"},
        {Tesla.Middleware.Headers, [{"user-agent", "github.com/mgwidmann/tesla_api"}]},
        Tesla.Middleware.JSON
      ] ++
        if(token,
          do: [{Tesla.Middleware.Headers, [{"Authorization", "Bearer " <> token}]}],
          else: []
        )

    Tesla.client(middleware, @adapter)
  end
end
