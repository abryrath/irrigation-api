defmodule Iri.Repo.Migrations.CreateForecasts do
  use Ecto.Migration

  def change do
    create table(:forecasts) do
      add :list, :text
      add :sunrise, :naive_datetime
      add :sunset, :naive_datetime
      add :lat, :float
      add :lng, :float
      add :zipcode, :string
      add :name, :string

      timestamps()
    end

  end
end
