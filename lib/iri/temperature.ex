defmodule Iri.Temperature do
  @kelvin_offset 272
  @fahrenheit_offset 32
  def fahrenheit_from_kelvin(kelvin, round \\ true) do
    fahrenheit = (9/5) * (kelvin - @kelvin_offset) + @fahrenheit_offset
    unless round do
      fahrenheit
    else
      {int, _} = Float.round(fahrenheit)
      |> Float.to_string()
      |> Integer.parse(10)
      int
    end
  end
end
