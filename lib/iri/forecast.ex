defmodule Iri.Forecast do

  use Ecto.Schema
  alias Iri.Forecast
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:lat, :lng, :name, :sunrise, :sunset, :zipcode, :list]}
  schema "forecasts" do
    field :lat, :float
    field :list, :string
    field :lng, :float
    field :name, :string
    field :sunrise, :naive_datetime
    field :sunset, :naive_datetime
    field :zipcode, :string

    timestamps()
  end


  @doc false
  def changeset(forecast, attrs) do
    forecast
    |> cast(attrs, [:list, :sunrise, :sunset, :lat, :lng, :zipcode, :name])
    |> validate_required([:list, :sunrise, :sunset, :lat, :lng, :zipcode, :name])
  end

  def from_resp({:ok, %{"city" => city, "list" => list}}) do
    %{
      "coord" => %{"lat" => lat, "lon" => lng},
      "name" => name,
      "sunrise" => sunrise,
      "sunset" => sunset
    } = city

    {:ok, json_list} = Jason.encode(list)

    attrs = %{
      "lat" => lat,
      "lng" => lng,
      "name" => name,
      "sunrise" => Iri.NaiveDateTime.from_timestamp!(sunrise),
      "sunset" => Iri.NaiveDateTime.from_timestamp!(sunset),
      "zipcode" => "28208",
      "list" => json_list
    }

    # IO.inspect attrs
    changeset(%Iri.Forecast{}, attrs)
  end

  def to_map(%Forecast{} = forecast) do
    forecast
    |> Map.put(:list, Jason.decode!(forecast.list))
  end
end
