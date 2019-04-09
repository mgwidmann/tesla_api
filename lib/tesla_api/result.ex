defmodule TeslaApi.Result do
  alias TeslaApi.Error
  alias Tesla.Env

  @spec handle({:ok | :error, Env.t() | atom}, (any -> any)) :: {:error, Error.t()} | {:ok, any}
  def handle(result, transform \\ & &1)

  def handle({:ok, %Env{status: status, body: %{"response" => response}}}, transform)
      when status >= 200 and status <= 299 and is_list(response) do
    {:ok, Enum.map(response, transform)}
  end

  def handle({:ok, %Env{status: status, body: %{"response" => response}}}, transform)
      when status >= 200 and status <= 299 do
    {:ok, transform.(response)}
  end

  def handle({:ok, %Env{status: 408, body: %{"error" => "vehicle unavailable:" <> _}} = e}, _) do
    msg = "Vehicle unavailable. It must be woken up to make the API call succeed."
    {:error, %Error{error: :vehicle_unavailable, message: msg, env: e}}
  end

  def handle({:ok, %Env{status: 504} = e}, _) do
    {:error, %Error{error: :timeout, message: "Gateway Timeout", env: e}}
  end

  def handle({:error, %Env{} = e}, _) do
    {:error, %Error{error: :unknown, message: "An unknown error has occurred.", env: e}}
  end

  def handle({:error, reason}, _) do
    {:error, %Error{error: reason, message: "An unknown error has occurred"}}
  end
end
