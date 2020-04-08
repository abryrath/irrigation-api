defmodule Iri.Repo.Migrations.CreateDates do
  use Ecto.Migration

  def change do
    create table(:dates) do
      add :year, :integer
      add :month, :integer
      add :day, :integer
      add :weekday, :string
      add :sunrise, :naive_datetime
      add :sunset, :naive_datetime

      timestamps()
    end

  end
end
