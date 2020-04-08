defmodule Iri.History do
  import Ecto.Query
  alias Iri.Repo
  alias Iri.Record

  def latest() do
    query = from r in Record,
      order_by: [desc: r.inserted_at],
      select: r,
      limit: 1
    Repo.one(query)
  end

  def create() do
    r = %Record{}
    Repo.insert!(r)
  end
end
