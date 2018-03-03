defmodule MirrorWeb.PageController do
  use MirrorWeb, :controller

  def index(conn, _params) do
  	rates = Mirror.get_rates
  	Enum.each(rates, fn {symbol, rate} -> %Mirror.Currency{symbol: symbol, rate: 1 / rate} |> Mirror.Repo.insert(on_conflict: :replace_all, conflict_target: :symbol) end)
    render conn, "index.html", btc_rate: 1 / rates["BTC"], eth_rate: 1 / rates["ETH"], bch_rate: 1 / rates["BCH"]
  end
end
