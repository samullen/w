defmodule W.DarkskyForecast do
  @key "a2be5b42ea2c80fdbf04cf4149d12193"

  def fetch(%{lat: lat, lon: lon}) do
    forecast_url(lat, lon)
    |> HTTPoison.get
    |> handle_response
  end

  def forecast_url(lat, lon) do
    uri = URI.parse("https://api.darksky.net/forecast/#{@key}/#{lat},#{lon}")
    query = URI.encode_query(%{exclude: "minutely,hourly,flags"})

    %URI{uri | query: query}
    |> to_string
  end

  def handle_response({ :ok, %{status_code: 200, body: body }}) do
    { :ok, Poison.Parser.parse!(body) }
  end

  def handle_response({ _, %{status_code: _, body: body}}) do
    { :error, body }
  end
end
