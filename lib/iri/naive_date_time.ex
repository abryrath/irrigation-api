defmodule Iri.NaiveDateTime do
  epoch = {{1970, 1, 1}, {0, 0, 0}}
  @epoch :calendar.datetime_to_gregorian_seconds(epoch)

  def from_timestamp(timestamp) do
    timestamp
    |> Kernel.+(@epoch)
    |> :calendar.gregorian_seconds_to_datetime
    |> NaiveDateTime.from_erl()
  end

  def from_timestamp!(timestamp) do
    {:ok, result} = from_timestamp(timestamp)
    result
  end
end
