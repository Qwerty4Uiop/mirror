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
  	{:ok, rates} = HTTPoison.get("https://min-api.cryptocompare.com/data/price?fsym=USD&tsyms=#{ @currencies }")
  	{:ok, rates} = Poison.decode(rates.body)
  	rates
  end

  def get_rates_with_timestamp(timestamp) do
  	{:ok, rates} = HTTPoison.get("https://min-api.cryptocompare.com/data/pricehistorical?fsym=USD&tsyms=#{ @currencies }&ts=#{ timestamp }")
    {:ok, rates} = Poison.decode(rates.body)
    rates["USD"]
  end

  def insert_rates(rates) do
  	rates
  	|> Enum.each(fn {symbol, rate} -> %Mirror.Currency{symbol: symbol, rate: 1 / rate} |> Mirror.Repo.insert end)
  end

  def update_rates(rates) do
  	rates
  	|> Enum.each(fn {symbol, rate} -> Mirror.Currency |> Mirror.Repo.get_by(symbol: symbol) |> Mirror.Currency.changeset(%{rate: 1 / rate}) |> Mirror.Repo.update end)
  end

  def to_timestamp(date_string, time_string) do
  	date = 
      if date_string != "" do
        String.split(date_string, "-") |> Enum.map(&(String.to_integer(&1)))|> List.to_tuple
      else
        Date.utc_today |> Date.to_erl
      end

    time = 
      if time_string != "" do
        String.split(time_string, ":") |> Enum.map(&(String.to_integer(&1))) |> List.to_tuple |> Tuple.append(0)
      else
        Time.utc_now |> Time.to_erl
      end

    :calendar.datetime_to_gregorian_seconds({date, time}) - :calendar.datetime_to_gregorian_seconds({{1970, 1, 1}, {0, 0, 0}})
  end

end
