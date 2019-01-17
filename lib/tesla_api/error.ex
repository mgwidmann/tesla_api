defmodule TeslaApi.Error do
  defstruct message: nil, env: nil, error: :unknown
  @type t :: %__MODULE__{message: String.t(), error: atom(), env: Tesla.Env.t()}
end
