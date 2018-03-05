defmodule MirrorWeb.PageController do
  use MirrorWeb, :controller
  @moduledoc """
  Запрос на / приводит к очищению базы, заполнению ее актуальными данными и рендерингу страницы на основании валют, находящихся в базе (может быть любое количество).
  """

  def index(conn, _params) do
  	Mirror.Currency
  	|> Mirror.Repo.all
  	|> Enum.each(&(Mirror.Repo.delete(&1)))

  	Mirror.get_rates
  	|> Mirror.insert_rates
    
    render conn, "index.html"
  end
end
