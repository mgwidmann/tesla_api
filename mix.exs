defmodule TeslaApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :tesla_api,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "~> 1.2"},
      {:hackney, "~> 1.14"},
      {:jason, "~> 1.0"}
    ]
  end
end
