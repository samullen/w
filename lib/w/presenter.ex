defmodule W.Presenter do
  def alerts(forecast) do
    _alerts(Map.get(forecast, "alerts", []))

    forecast
  end
  defp _alerts([]), do: []

  defp _alerts([alert|alerts]) do
    IO.puts "#{IO.ANSI.red}#{IO.ANSI.bright}ALERT: #{alert["title"]}#{IO.ANSI.normal}\n"
    IO.puts "#{alert["description"]}\n"
    IO.puts "URL: #{alert["uri"]}"
    IO.puts IO.ANSI.default_color

    _alerts(alerts)
  end

  def current_conditions(%{"currently" => conditions} = forecast) do
    IO.puts """

      #{IO.ANSI.bright}#{Float.ceil(conditions["temperature"])}° #{conditions["summary"]}#{IO.ANSI.normal}

      #{IO.ANSI.bright}Humidity:#{IO.ANSI.normal} #{conditions["humidity"] * 100}%
      #{IO.ANSI.bright}Wind:#{IO.ANSI.normal}     #{wind_direction(conditions["windBearing"])} #{Float.ceil(conditions["windSpeed"])}
      """

    forecast
  end

  def daily_forecast(%{"daily" => daily_hash}) do
    _daily_forecast(daily_hash["data"])
  end
  defp _daily_forecast([]), do: []
  defp _daily_forecast([day|days]) do
    IO.puts DateTime.from_unix!(day["time"])

    _daily_forecast(days)
  end

  defp wind_direction(nil), do: "N/A"
  defp wind_direction(bearing) do
    case bearing do
      direction when direction in 0..22 -> "N"
      direction when direction in 23..67 -> "NW"
      direction when direction in 68..112 -> "W"
      direction when direction in 113..157 -> "SW"
      direction when direction in 158..203 -> "S"
      direction when direction in 204..248 -> "SE"
      direction when direction in 249..292 -> "E"
      direction when direction in 293..337 -> "NE"
      direction when direction in 338..360 -> "N"
      _ -> "N/A"
    end
  end
end
