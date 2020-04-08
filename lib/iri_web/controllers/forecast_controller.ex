defmodule IriWeb.ForecastController do
  use IriWeb, :controller

  def today(conn, _params) do
    date = Iri.OpenWeather.weather_today("28208")
    json(conn, date)
  end
end
