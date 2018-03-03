defmodule MirrorWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:lobby", _message, socket) do
  	:timer.send_interval(5000, :ping)
    {:ok, socket}
  end

  def handle_info(:ping, socket) do
  	rates = Mirror.get_rates
  	push socket, "rates_refresh", rates
  	{:noreply, socket}
  end

end