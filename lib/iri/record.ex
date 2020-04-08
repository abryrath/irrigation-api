defmodule Iri.Record do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:inserted_at]}
  schema "records" do
    timestamps()
  end

  @doc false
  def changeset(record, attrs) do
    record
    |> cast(attrs, [])
    |> validate_required([])
  end
end
