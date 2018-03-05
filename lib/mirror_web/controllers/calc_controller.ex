defmodule MirrorWeb.CalcController do
  use MirrorWeb, :controller
  @moduledoc """
  Контроллер раута /calc преобразовывает дату в таймстемп и перенаправляет на страницу соответствующей валюты с количеством и таймтемпом в качестве параметров запроса.
  Контроллер раута /calc:currency отправляет запрос на рейт указанной валюты на указанный таймстемп, после чего рендерит страницу с полученной информацией.
  Если от api приходит нулевой рейт, значит на заданную дату нет информации, в таком случае выводится сообщение об этом. (логика в calc/index.html.eex)
  """

  def index(conn, params) do
    timestamp = Mirror.to_timestamp(params["date"], params["time"])

    redirect conn, to: "/calc/" <> params["currency"] <> "?amount=" <> params["amount"] <> "&timestamp=#{ timestamp }"
  end

  def calculate(conn, params) do
    currency = params["currency"]
    timestamp = params["timestamp"]
    {:ok, rate} = HTTPoison.get("https://min-api.cryptocompare.com/data/pricehistorical?fsym=#{ currency }&tsyms=USD&ts=#{ timestamp }")
    {:ok, rate} = Poison.decode(rate.body)
    render conn, "index.html", amount: params["amount"], symbol: params["currency"], sum: rate[currency]["USD"] * String.to_integer(params["amount"])
  end

end