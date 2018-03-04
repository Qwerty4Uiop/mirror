defmodule MirrorWeb.RatesChannelTest do
  use MirrorWeb.ChannelCase

  alias MirrorWeb.RatesChannel

  setup do
    Mirror.Repo.insert(%Mirror.Currency{symbol: "BTC", rate: 1234.0})
    Mirror.Repo.insert(%Mirror.Currency{symbol: "BCH", rate: 1234.0})
    Mirror.Repo.insert(%Mirror.Currency{symbol: "ETH", rate: 1234.0})
    Mirror.Currency |> Mirror.Repo.all |> IO.inspect
    {:ok, _, socket} =
      socket()
      |> subscribe_and_join(RatesChannel, "rates:update")

    {:ok, socket: socket}
  end

  # test "ping replies with status ok", %{socket: socket} do
  #   ref = push socket, "ping", %{"hello" => "there"}
  #   assert_reply ref, :ok, %{"hello" => "there"}
  # end

  # test "ping replies with status ok", %{socket: socket} do
  #   Mirror.Currency |> Mirror.Repo.all |> IO.inspect
  #   push socket, "force_update", %{date: "2018-03-03", time: "10:00"}
  #   assert_push "rates_refresh", %{rates: %{}, timestamp: 1520071200}
  # end

  # test "shout broadcasts to room:lobby", %{socket: socket} do
  #   push socket, "force_update", %{date: "2018-03-03", time: "10:00"}
  #   assert_broadcast "rates_refresh", %{rates: _, timestamp: 1520071200}
  # end

  # test "broadcasts are pushed to the client", %{socket: socket} do
  #   broadcast_from! socket, "broadcast", %{"some" => "data"}
  #   assert_push "broadcast", %{"some" => "data"}
  # end
end
