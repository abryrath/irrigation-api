defmodule Iri.Repo.Migrations.CreateForecasts do
  use Ecto.Migration

  def change do
    create table(:forecasts) do
      add :hour, :integer
      add :humidity, :integer
      add :temp, :integer
      add :feels_like, :integer
      add :description, :string
      add :summary, :string
      add :wind_speed, :float
      add :wind_dir, :integer
      add :pressure, :integer
      add :date_id, references(:dates)
      timestamps()
    end

  end
end
