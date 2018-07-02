defmodule W.Presenter do
  def alerts(forecast) do
    _alerts(Map.get(forecast, "alerts", []))

    forecast
  end
  defp _alerts([]), do: []

  defp _alerts([alert|alerts]) do
    IO.puts "#{IO.ANSI.red}#{IO.ANSI.bright}ALERT: #{alert["title"]}#{IO.ANSI.normal}#{IO.ANSI.default_color}\n"
    IO.puts alert["description"]
    IO.puts "URL: #{alert["uri"]}"
    IO.puts IO.ANSI.normal

    _alerts(alerts)
  end

  def current_conditions(%{"currently" => conditions} = forecast) do
    IO.puts "#{IO.ANSI.red}#{IO.ANSI.bright}#{conditions["summary"]} #{conditions["temperature"]}#{IO.ANSI.normal}#{IO.ANSI.default_color}"
    IO.puts "Humidity: #{conditions["humidity"]}"
    IO.puts "Wind: #{conditions["windSpeed"]}/#{conditions["windGust"]}"

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
end
