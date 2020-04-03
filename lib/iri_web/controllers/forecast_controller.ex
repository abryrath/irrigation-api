defmodule IriWeb.ForecastController do
  use IriWeb, :controller

  def today(conn, _params) do
    forecast = Iri.OpenWeather.weather_today("28208")
    json(conn, Iri.Forecast.to_map(forecast))
  end
end
