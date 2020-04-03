defmodule IriWeb.PageController do
  use IriWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
