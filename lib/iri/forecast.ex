defmodule Iri.Forecast do
  use Ecto.Schema
  alias Iri.{Forecast, Date, Temperature}
  import Ecto.Changeset

  @fields [
    :hour,
    :humidity,
    :temp,
    :feels_like,
    :description,
    :summary,
    :wind_speed,
    :wind_dir,
    :pressure
  ]
  @json_fields @fields ++ [:inserted_at]
  @derive {Jason.Encoder, only: @fields}
  schema "forecasts" do
    field :hour, :integer
    field :humidity, :integer
    field :temp, :integer
    field :feels_like, :integer
    field :description, :string
    field :summary, :string
    field :wind_speed, :float
    field :wind_dir, :integer
    field :pressure, :integer
    belongs_to :date, Date
    timestamps()
  end

  @doc false
  def changeset(forecast, attrs) do
    forecast
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end

  defp get_hour_from_timestamp(timestamp) do
    datetime = Iri.NaiveDateTime.from_timestamp!(timestamp)
    {_, {hour, _, _}} = NaiveDateTime.to_erl(datetime)
    hour
  end

  def from_resp(
        %{"dt" => dt, "main" => main, "weather" => weather, "wind" => wind},
        %Date{} = date
      ) do
    forecast_date = Iri.NaiveDateTime.from_timestamp!(dt)

    year = date.year
    month = date.month
    day = date.day
    IO.inspect(date)
    IO.puts("Forecast date:")
    IO.inspect(forecast_date)

    # if this doesnt match the date, then ignore it
    case NaiveDateTime.to_erl(forecast_date) do
      {{^year, ^month, ^day}, _} ->
        hour = get_hour_from_timestamp(dt)

        %{
          "feels_like" => feels_like,
          "humidity" => humidity,
          "pressure" => pressure,
          "temp" => temp
        } = main

        IO.inspect(weather)
        %{"description" => description, "main" => summary} = Enum.at(weather, 0)
        %{"deg" => wind_dir, "speed" => wind_speed} = wind

        attrs = %{
          :hour => hour,
          :humidity => humidity,
          :temp => Temperature.fahrenheit_from_kelvin(temp),
          :feels_like => Temperature.fahrenheit_from_kelvin(feels_like),
          :description => description,
          :summary => summary,
          :wind_speed => elem(Float.parse("#{wind_speed}"), 0),
          :wind_dir => wind_dir,
          :pressure => pressure
        }

        # IO.inspect attrs
        forecast = Ecto.build_assoc(date, :forecasts, attrs)
        {:ok, forecast}

      _ ->
        {:err, "Forecast is not for today"}
    end
  end
end
