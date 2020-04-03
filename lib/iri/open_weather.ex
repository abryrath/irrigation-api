defmodule Iri.OpenWeather do
  # import Ecto.Date
  alias Iri.Forecast
  alias Iri.Repo

  import Ecto.Query

  @api_key System.get_env("OPEN_WEATHER_API_KEY") ||
             raise("Open weather api key is not specified")

  @domain "api.openweathermap.org"
  @uri "/data/2.5/forecast?zip={{zip}}&appid={{api_key}}"

  def uri(zip \\ "28208") do
    @uri
    |> String.replace("{{zip}}", zip)
    |> String.replace("{{api_key}}", @api_key)
  end

  def weather_today(zip \\ "28208") do
    # Check the db first

    forecast =
      case get_today_from_repo() do
        nil ->
          api_get()
          |> parse_resp
          |> Forecast.from_resp()
          |> Repo.insert!()

        result ->
          result
      end

    forecast
  end

  def get_today_from_repo() do
    query =
      from f in Forecast,
        where: f.inserted_at >= datetime_add(^NaiveDateTime.utc_now(), -1, "day"),
        select: f

    Repo.one(query)
  end

  defp api_get(zip \\ "28208") do
    {:ok, conn} = Mint.HTTP.connect(:https, @domain, 443)
    {:ok, conn, request_ref} = Mint.HTTP.request(conn, "GET", uri(zip), [], "")

    responses =
      receive do
        message ->
          {:ok, conn, responses} = Mint.HTTP.stream(conn, message)
          responses
      end

    Mint.HTTP.close(conn)
    responses
  end

  defp parse_resp(responses) do
    # IO.inspect(responses)
    [{:status, _, 200}, _headers, data_resp, _done] = responses
    {:data, _, data} = data_resp
    Jason.decode(data)
  end
end
