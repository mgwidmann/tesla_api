defmodule TeslaApi.Auth do
  import TeslaApi

  @type token() :: String.t()
  defstruct [:token, :type, :expires_in, :refresh_token, :created_at]
  @type t :: %__MODULE__{token: token()}

  @client_id "81527cff06843c8634fdc09e8ac0abefb46ac849f38fe1e431c2ef2106796384"
  @client_secret "c7257eb71a564034f9419ee651c7d0e5f7aa6bfbd18bafb5c5c033b093bb2fa3"

  @doc """
  Performs a login action to get a new authentication token.
  """
  @spec login(String.t(), String.t()) :: t() | TeslaApi.Error.t()
  def login(email, password) do
    request(:post, "/oauth/token", nil, %{
      "grant_type" => "password",
      "client_id" => @client_id,
      "client_secret" => @client_secret,
      "email" => email,
      "password" => password
    })
    |> handle_response()
  end

  @doc """
  Uses the refresh token gained from authentication in order to get a new token and refresh token.
  """
  @spec refresh(t()) :: t() | TeslaApi.Error.t()
  def refresh(%TeslaApi.Auth{token: token, refresh_token: refresh_token}) do
    request(:post, "/oauth/token", token, %{
      "grant_type" => "refresh_token",
      "client_id" => @client_id,
      "client_secret" => @client_secret,
      "refresh_token" => refresh_token
    })
    |> handle_response()
  end

  defp handle_response({:ok, %Tesla.Env{body: auth}}) do
    %__MODULE__{
      token: auth["access_token"],
      type: auth["token_type"],
      expires_in: auth["expires_in"],
      refresh_token: auth["refresh_token"],
      created_at: auth["created_at"]
    }
  end

  defp handle_response({:error, e = %Tesla.Env{}}) do
    %TeslaApi.Error{error: :authentication_failure, message: "Failed to authenticate.", env: e}
  end
end
