defmodule Iri.NaiveDateTime do
  def from_timestamp!(timestamp) do
    DateTime.from_unix!(timestamp)
    |> DateTime.shift_zone!("America/New_York")
    |> DateTime.to_naive()
  end
end
