defmodule Mirror do
	@moduledoc """
  Константа @currencies содержит валюты, используемые в приложении, может быть любое количество.

  Замечание:
  При запросе от api актуальной информации, возвращаются рейты, не равные тем, что приходят в ответ на запрос рейтов с указанием актуального таймстемпа.
  Это приводит к тому, что, при нажатии кнопки "Refresh rates" сразу после автоматического обновления рейтов, результаты могут отличаться от тех, что были выведены ранее.
  Не стал писать костыли под это, потому как счел ту логику работы приложения, что представлена, верной.
  """
  @currencies "BTC,ETH,BCH"

  @doc """
  Запрашивает и возвращает актуальную информацию о рейтах.
  Производится запрос на отношение доллара к валютам и последующее преобразование полученных рейтов в обратное значение.
  Запрос именно на такое отношение, а не обратное ему, потому что api не поддерживает запросы на отношение нескольких валют к одной, соответственно, таким образом сокращается количество запросов.
  """
  def get_rates do
  	{:ok, rates} = HTTPoison.get("https://min-api.cryptocompare.com/data/price?fsym=USD&tsyms=#{ @currencies }")
  	{:ok, rates} = Poison.decode(rates.body)

  	rates 
  	|> Enum.map(fn {symbol, rate} -> if rate == 0, do: {symbol, 0}, else: {symbol, 1 / rate} end)
  	|> Map.new
  end

  @doc """
  Запрашивает и возвращает значение рейтов на указанный таймстемп
  """
  def get_rates_with_timestamp(timestamp) do
  	{:ok, rates} = HTTPoison.get("https://min-api.cryptocompare.com/data/pricehistorical?fsym=USD&tsyms=#{ @currencies }&ts=#{ timestamp }")
    {:ok, rates} = Poison.decode(rates.body)

    rates["USD"]
    |> Enum.map(fn {symbol, rate} -> if rate == 0, do: {symbol, 0}, else: {symbol, 1 / rate} end)
  	|> Map.new
  end

  @doc """
	Заполняет таблицу рейтов валют переданными значениями
  """
  def insert_rates(rates) do
  	rates
  	|> Enum.each(fn {symbol, rate} ->
  		          	 %Mirror.Currency{symbol: symbol, rate: rate}
  		           	 |> Mirror.Repo.insert
  		           end)
  end

  @doc """
  Обновляет информацию в таблице рейтов валют переданными значениями
  """
  def update_rates(rates) do
  	rates
  	|> Enum.each(fn {symbol, rate} -> 
  		             Mirror.Currency
  		             |> Mirror.Repo.get_by(symbol: symbol)
  		             |> Mirror.Currency.changeset(%{rate: rate})
  		             |> Mirror.Repo.update 
  		           end)
  end

  @doc """
  Преобразовывает строковую дату и время в таймстемп
  """
  def to_timestamp(date_string, time_string) do
  	date = 
      if date_string != "" do
        String.split(date_string, "-")
        |> Enum.map(&(String.to_integer(&1)))
        |> List.to_tuple
      else
        Date.utc_today
        |> Date.to_erl
      end

    time = 
      if time_string != "" do
        String.split(time_string, ":")
        |> Enum.map(&(String.to_integer(&1)))
        |> List.to_tuple
        |> Tuple.append(0)
      else
        Time.utc_now
        |> Time.to_erl
      end

    :calendar.datetime_to_gregorian_seconds({date, time}) - :calendar.datetime_to_gregorian_seconds({{1970, 1, 1}, {0, 0, 0}})
  end

end
