defmodule MirrorWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:lobby", _message, socket) do
  	:timer.send_interval(10000, :refresh)
    {:ok, socket}
  end

  def handle_info(:refresh, {some_data, socket}) do
  	rates = update()
  	push socket, "rates_refresh", rates
  	{:noreply, socket}
  end

  def handle_in("rates_refresh", _msg, {some_data, socket}) do
  	rates = update()
  	push socket, "rates_refresh", rates
  	{:noreply, socket}
  end

  def update() do
  	rates = Mirror.get_rates
  	Mirror.update_rates(rates)
  	rates
  end
end