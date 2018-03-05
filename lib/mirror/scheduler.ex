defmodule Mirror.Scheduler do
  use GenServer
  @moduledoc """
  Обеспечивает обновление рейтов по расписанию.

  Принцип работы:
  Модуль реализует generic server process. При инициализации подписывается на подраздел "force" канала "rates".
  На этот подраздел канал "rates" "перенаправляет" все сообщения с фронта.
  Сообщений может быть два типа: "start_updating" и "force_update".

  "start_updating":
  Отправляется сразу после установления соединения и по нажатию на кнопку "Continue refreshing".
  Соответственно, инициирует старт работы по расписанию.
  Работа по расписанию реализована следующим образом:
  В состоянии модуля хранятся ссылка на активный таймер(:timer_ref) и счетчик(:counter).
  В начале работы вызывается функция schedule_timer(interval), которая устанавливает таймер равный interval на отправку своему модулю сообщения :update и возвращает ссылку на этот таймер.
  У модуля есть два обработчика этого сообщения: первый вызывается в случае, если счетчик, находящайся внутри состояния модуля отличен от нуля.
  В этом случае снова вызывается функция schedule_timer(interval), а в поле :timer_ref заносится ссылка на новый таймер, а в поле :counter - его декрементированное значение.
  Второй обработчик вызывается, когда счетчик достигает нуля.
  Он собирает актуальную информацию о рейтах и отправляет на фронт сообщение "rates_refresh" с полученной информацией, после чего обновляет :timer_ref и сбрасывает счетчик.

  "force_update":
  Отправляется после нажатия на кнопку "Refresh rates".
  Останавливает таймер, после чего собирает информацию на пришедшее время и отправляет на фронт сообщение "rates_refresh" с новой информацией.

  Константа @interval задает значение интервала обновления рейтов в секундах
  """
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