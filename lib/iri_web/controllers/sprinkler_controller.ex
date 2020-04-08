defmodule IriWeb.SprinklerController do
  use IriWeb, :controller
  alias Iri.History
  alias Iri.Sprinker

  @doc """
  Run the sprinkler without any params
  """
  def default(conn, _params) do
    # Create a record that it was run
    History.create()
    conn
  end
end
