defmodule Iri.OpenWeather do
  # import Ecto.Date
  alias Iri.{Forecast,Repo,Date}

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
          |> parse_resp()

        result ->
          result
      end

    IO.inspect(forecast)
    forecast
  end

  def get_today_from_repo() do
    {{year, month, day}, _} = :calendar.universal_time()

    query =
      from d in Date,
        where: d.year == ^year and d.month == ^month and d.day == ^day,
        preload: :forecasts,
        limit: 1,
        select: d

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
    {:ok, struct} = Jason.decode(data)
    # only keep the next 5 forecasts
    %{"list" => list, "city" => city} = struct
    date = Date.from_resp(city)
    |> Repo.insert!()
    # date
    # # |> Ecto.Schema.build_assoc(:forecasts, forecasts)
    # |> Repo.insert!()

    forecasts = save_forecasts(list, date)

    get_today_from_repo()
  end

  defp save_forecasts(input, date, forecasts \\ [])
  defp save_forecasts([], _date, forecasts), do: forecasts
  defp save_forecasts([head|tail], date, forecasts) do
    case Forecast.from_resp(head, date) do
      {:ok, forecast} ->
        Repo.insert!(forecast)
        save_forecasts(tail, date, [forecast|forecasts])
      {:err, reason} ->
        IO.puts reason
        save_forecasts(tail, date, forecasts)
    end
  end
end
