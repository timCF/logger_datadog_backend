defmodule LoggerDatadogBackend.Mixfile do
  use Mix.Project

  @version "0.1.1"

  def project do
    [app: :logger_datadog_backend,
     version: @version,
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     description: "a datadog backend for ExLogger",
     package: package(),
     docs: docs()]
  end

  def application do
    [applications: [:logger, :ex_statsd]]
  end

  defp deps do
    [{:ex_statsd, ">= 0.5.1"},
     {:ex_doc, ">= 0.0.0", only: :dev},
     {:credo, ">= 0.6.1", only: :dev},
     {:dialyxir, "~> 0.4", only: [:dev], runtime: false}]
  end

  defp package do
    [
      maintainers: ["Matteo Giachino"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/matteosister/logger_datadog_backend"}
    ]
  end

  defp docs do
    [
      source_url: "https://github.com/matteosister/logger_datadog_backend",
      source_ref: "v#{@version}",
      extras: ["README.md"], main: "readme"
    ]
  end
end
