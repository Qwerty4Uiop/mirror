defmodule MirrorWeb.RatesChannel do
  use Phoenix.Channel
  @moduledoc """
  Устанавливает соединение с фронтом и перенаправляет сообщения Scheduler'у.
  Принцип его работы описан в документации к модулю Mirror.Scheduler
  """
  def join("rates:update", _message, socket) do
    {:ok, socket}
  end

  def handle_in("force_update", datetime, socket) do
    MirrorWeb.Endpoint.broadcast("rates:force", "force_update", datetime)
    {:noreply, socket}
  end

  def handle_in("start_updating", _msg, socket) do
    MirrorWeb.Endpoint.broadcast("rates:force", "start_updating", %{})
    {:noreply, socket}
  end

end