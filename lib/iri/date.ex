defmodule Iri.Date do
  use Ecto.Schema
  import Ecto.Changeset
  alias Iri.Forecast

  @fields [:year, :month, :day, :weekday, :sunrise, :sunset]
  @json_fields @fields ++ [:inserted_at, :forecasts]
  @weekdays ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

  @derive {Jason.Encoder, only: @json_fields}
  schema "dates" do
    field :day, :integer
    field :month, :integer
    field :sunrise, :naive_datetime
    field :sunset, :naive_datetime
    field :weekday, :string
    field :year, :integer
    has_many :forecasts, Forecast
    timestamps()
  end

  @doc false
  def changeset(date, attrs) do
    date
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end

  defp parse_forecasts(params) do

  end

  def from_resp(%{"sunrise" => sunrise, "sunset" => sunset}) do
    sunrise = Iri.NaiveDateTime.from_timestamp!(sunrise)
    sunset = Iri.NaiveDateTime.from_timestamp!(sunset)
    erlang_format = NaiveDateTime.to_erl(sunrise)
    {{year, month, day}, _} = erlang_format
    weekday = Enum.at(@weekdays, :calendar.day_of_the_week(year, month, day))

    attrs = %{
      :sunrise => sunrise,
      :sunset => sunset,
      :year => year,
      :month => month,
      :day => day,
      :weekday => weekday
    }
    changeset(%Iri.Date{}, attrs)
  end
end
