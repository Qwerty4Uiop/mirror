defmodule MirrorWeb.PageController do
  use MirrorWeb, :controller

  def index(conn, _params) do
  	# Clear table "currencies"
  	Mirror.Currency
  	|> Mirror.Repo.all
  	|> Enum.each(&(Mirror.Repo.delete(&1)))

  	Mirror.get_rates
  	|> Mirror.insert_rates
    
    render conn, "index.html"
  end
end
