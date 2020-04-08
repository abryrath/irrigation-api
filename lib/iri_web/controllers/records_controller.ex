defmodule IriWeb.RecordsController do
  use IriWeb, :controller

  def latest(conn, _params) do
    record = Iri.History.latest()
    json(conn, record)
  end
end
