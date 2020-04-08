defmodule Iri.Repo.Migrations.CreateRecords do
  use Ecto.Migration

  def change do
    create table(:records) do

      timestamps()
    end

  end
end
