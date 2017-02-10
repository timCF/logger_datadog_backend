defmodule LoggerDatadogBackend do
  @moduledoc """
  implementation for ExLogger backend
  """
  use GenEvent

  defstruct [level: nil, enabled: false]

  @type timestamp :: {{integer, integer, integer}, {integer, integer, integer, integer}}

  @doc false
  @spec init(atom) :: {:ok, %LoggerDatadogBackend{}}
  def init(__MODULE__) do
    config = Application.get_env(:logger, __MODULE__, level: :warn)
    enabled = case Code.ensure_loaded(ExStatsD) do
      {:module, _} -> true
      _ -> false
    end

    {:ok, init(config, %__MODULE__{enabled: enabled})}
  end

  @doc false
  @spec handle_event({Logger.level, atom, {Logger, Logger.message, timestamp, Keyword.t}}, %LoggerDatadogBackend{}) :: {:ok, %LoggerDatadogBackend{}}
  def handle_event({level, _group_leader, {Logger, _message, _timestamp, _metadata}}, state) do
    %{level: log_level, enabled: enabled} = state
    cond do
      not meet_level?(level, log_level) -> {:ok, state}
      not enabled -> {:ok, state}
      :otherwise -> {:ok, log_event(level, state)}
    end
  end

  @spec init(Keyword.t, %LoggerDatadogBackend{}) :: %LoggerDatadogBackend{}
  defp init(config, state) do
    level = Keyword.get(config, :level)

    %{state | level: level}
  end

  @spec meet_level?(Logger.level, nil) :: boolean
  defp meet_level?(_lvl, nil), do: true
  defp meet_level?(lvl, min) do
    Logger.compare_levels(lvl, min) != :lt
  end

  @spec log_event(Logger.level, %LoggerDatadogBackend{}) :: %LoggerDatadogBackend{}
  defp log_event(level, state) do
    ExStatsD.increment("logger.#{level}")
    state
  end
end
