# LoggerDatadogBackend

A simple backend for ExLogger that increment a counter for the log level triggered.

Useful to keep an eye on your application and add alerting based on changes in error frequencies.

## Installation

The package can be installed with hex as:

  1. Add `logger_datadog_backend` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:logger_datadog_backend, "~> 0.1"}]
    end
    ```

  2. Ensure `logger_datadog_backend` is started before your application:

    ```elixir
    def application do
      [applications: [:logger_datadog_backend]]
    end
    ```
## Configuration

This library depends on [ex_statsd](https://hex.pm/packages/ex_statsd). So make sure to include
the configuration for that library or it won't work. Here is an example:

```elixir
use Mix.Config

# ex_statsd configuration
config :ex_statsd,
  host: "your.statsd.host.com",
  port: 1234,
  namespace: "your-app"

# ex_logger configuration
config :logger,
  backends: [:console, LoggerDatadogBackend] # for production you can also disable the :console backend

# logger_datadog_backend configuration
config :logger, LoggerDatadogBackend,
  level: :warn # minimum level to report to datadog
```

## How it works

the backend will listen to every logger message in your application and report the level on datadog as a counter.
With the configuration above the counter will be:

  - your-app.logger.warn
  - your-app.logger.error
