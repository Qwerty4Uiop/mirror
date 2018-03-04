defmodule MirrorWeb.CalcController do
  use MirrorWeb, :controller

  def index(conn, params) do
    timestamp = Mirror.to_timestamp(params["date"], params["time"])

    redirect conn, to: "/calc/" <> params["currency"] <> "?amount=" <> params["amount"] <> "&timestamp=#{ timestamp }"
  end

  def calculate(conn, params) do
    IO.puts(params["hui"])
    currency = params["currency"]
    timestamp = params["timestamp"]
    {:ok, rate} = HTTPoison.get("https://min-api.cryptocompare.com/data/pricehistorical?fsym=#{ currency }&tsyms=USD&ts=#{ timestamp }")
    {:ok, rate} = Poison.decode(rate.body)
    render conn, "index.html", amount: params["amount"], symbol: params["currency"], sum: rate[currency]["USD"] * String.to_integer(params["amount"])
  end

end