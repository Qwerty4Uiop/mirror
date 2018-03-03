defmodule MirrorWeb.CalcController do
  use MirrorWeb, :controller

  def index(conn, params) do
    date = 
      if params["date"] != "" do
        String.split(params["date"], "-") |> Enum.map(&(String.to_integer(&1)))|> List.to_tuple
      else
        Date.utc_today |> Date.to_erl
      end

    time = 
      if params["time"] != "" do
        String.split(params["time"], ":") |> Enum.map(&(String.to_integer(&1))) |> List.to_tuple |> Tuple.append(0)
      else
        Time.utc_now |> Time.to_erl
      end

    redirect conn, to: "/calc/" <> params["currency"] <> "?amount=" <> params["amount"] <> "&timestamp=#{ to_timestamp({date, time}) }"
  end

  def calculate(conn, params) do
    IO.puts(params["hui"])
    currency = params["currency"]
    timestamp = params["timestamp"]
    {:ok, rate} = HTTPoison.get("https://min-api.cryptocompare.com/data/pricehistorical?fsym=#{ currency }&tsyms=USD&ts=#{ timestamp }")
    {:ok, rate} = Poison.decode(rate.body)
    render conn, "index.html", amount: params["amount"], symbol: params["currency"], sum: rate[currency]["USD"] * String.to_integer(params["amount"])
  end

  def to_timestamp(datetime) do
    :calendar.datetime_to_gregorian_seconds(datetime) - :calendar.datetime_to_gregorian_seconds({{1970, 1, 1}, {0, 0, 0}})
  end
end