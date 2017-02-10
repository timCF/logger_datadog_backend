defmodule LoggerDatadogBackend do
  @moduledoc """
  implementation for ExLogger backend
  """
  use GenEvent

  defstruct [level: nil, enabled: false]

  @doc false
  def init(__MODULE__) do
    config = Application.get_env(:logger, __MODULE__)
    enabled = case Code.ensure_loaded(ExStatsD) do
      {:module, _} -> true
      _ -> false
    end

    {:ok, init(config, %__MODULE__{enabled: enabled})}
  end

  @doc false
  def handle_event({level, _group_leader, {Logger, _message, _timestamp, _metadata}}, state) do
    %{level: log_level, enabled: enabled} = state
    cond do
      not meet_level?(level, log_level) -> {:ok, state}
      not enabled -> {:ok, state}
      :otherwise -> {:ok, log_event(level, state)}
    end
  end

  defp init(config, state) do
    level = Keyword.get(config, :level)

    %{state | level: level}
  end

  defp meet_level?(_lvl, nil), do: true

  defp meet_level?(lvl, min) do
    Logger.compare_levels(lvl, min) != :lt
  end

  defp log_event(level, state) do
    ExStatsD.increment("logger.#{level}")
    state
  end
end
