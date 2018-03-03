defmodule MirrorWeb.PageController do
  use MirrorWeb, :controller

  def index(conn, _params) do
  	# Clear table "currencies"
  	Mirror.Currency
  	|> Mirror.Repo.all
  	|> Enum.each(&(Mirror.Repo.delete(&1)))

  	Mirror.get_rates
  	# Inserting actual data
  	|> Enum.each(fn {symbol, rate} -> %Mirror.Currency{symbol: symbol, rate: 1 / rate} |> Mirror.Repo.insert end)
    
    render conn, "index.html"
  end
end
