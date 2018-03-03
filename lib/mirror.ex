defmodule Mirror do
  @currencies "BTC,ETH,BCH"
  @moduledoc """
  Mirror keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def get_rates do
  	#Conversion from USD to BTC, ETH and BCH, and not vice versa, because api does not support conversion from multiple currencies to one, so this results in fewer requests
  	{:ok, rates} = HTTPoison.get("https://min-api.cryptocompare.com/data/price?fsym=USD&tsyms=#{@currencies}")
  	{:ok, rates} = Poison.decode(rates.body)
  	rates
  end
end
