defmodule Mirror.Scheduler do
  use GenServer

  # Rates update interval in seconds
  @interval 10

  def start_link() do
    GenServer.start_link __MODULE__, %{}
  end

  def init(_state) do
    MirrorWeb.Endpoint.subscribe "rates:force", []
    state = %{timer_ref: nil, counter: nil}
    {:ok, state}
  end

  def handle_info(:update, %{counter: 0}) do
    rates = Mirror.get_rates
    current_ts = :os.system_time(:seconds)
    Mirror.update_rates(rates)
    rates = Map.new(rates: rates, timestamp: current_ts)
    MirrorWeb.Endpoint.broadcast! "rates:update", "rates_refresh", rates
    timer_ref = schedule_timer 1000
    {:noreply, %{timer_ref: timer_ref, counter: @interval}}
  end

  def handle_info(:update, %{counter: counter}) do
    timer_ref = schedule_timer 1000
    {:noreply, %{timer_ref: timer_ref, counter: counter - 1}}
  end

  def handle_info(%{event: "start_updating"}, %{timer_ref: old_timer_ref}) do
    cancel_timer(old_timer_ref)
    timer_ref = schedule_timer 1000
    {:noreply, %{timer_ref: timer_ref, counter: @interval}}
  end

  def handle_info(%{event: "force_update", payload: %{"date" => date, "time" => time}}, %{timer_ref: old_timer_ref}) do
    cancel_timer(old_timer_ref)
    timestamp = Mirror.to_timestamp(date, time)
    rates = Mirror.get_rates_with_timestamp(timestamp)
    Mirror.update_rates(rates)
    rates = Map.new(rates: rates, timestamp: timestamp)
    MirrorWeb.Endpoint.broadcast! "rates:update", "rates_refresh", rates
    {:noreply, %{timer_ref: nil, counter: nil}}
  end

  defp schedule_timer(interval), do: Process.send_after self(), :update, interval

  defp cancel_timer(nil), do: :ok
  defp cancel_timer(ref), do: Process.cancel_timer(ref)

end