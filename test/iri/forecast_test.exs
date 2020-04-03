defmodule Iri.ForecastText do
  use ExUnit.Case

  test "parse response" do
    resp = File.read!("./json-resp.json")
    {:ok, json} = Jason.decode(resp)
    forecast = Iri.Forecast.from_resp(json)

    # IO.inspect forecast.sunrise
    unless forecast.valid? do
      raise """
        Forecast is invalid. #{inspect(forecast.errors)}
      """
    end

    assert forecast.valid? == true
  end
end
