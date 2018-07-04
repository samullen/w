defmodule W.Presenter do
  def alerts(forecast) do
    _alerts(Map.get(forecast, "alerts", []))

    forecast
  end
  defp _alerts([]), do: []

  defp _alerts([alert|alerts]) do
    IO.puts """
      #{IO.ANSI.red}#{IO.ANSI.bright}ALERT: #{alert["title"]}#{IO.ANSI.normal}

      #{alert["description"]}
      URL: #{alert["uri"]}
      #{IO.ANSI.default_color}
      """

    _alerts(alerts)
  end

  def current_conditions(%{"currently" => conditions} = forecast) do
    IO.puts """
      #{IO.ANSI.bright}#{temperature(conditions["temperature"])} #{conditions["summary"]}#{IO.ANSI.normal}

      #{IO.ANSI.bright}Humidity:#{IO.ANSI.normal} #{conditions["humidity"] * 100}%
      #{IO.ANSI.bright}Wind:#{IO.ANSI.normal}     #{wind(conditions)}
      """

    forecast
  end

  def daily_forecast(%{"daily" => daily_hash}) do
    _daily_forecast(daily_hash["data"])
  end
  defp _daily_forecast([]), do: []
  defp _daily_forecast([day|days]) do
    IO.puts "#{day_name(day["time"])} #{overview(day)}  #{hilo(day)} #{wind(day)}"

    _daily_forecast(days)
  end

  defp wind_direction(nil), do: "N/A"
  defp wind_direction(bearing) do
    case bearing do
      direction when direction in 0..22 -> "N "
      direction when direction in 23..67 -> "NW"
      direction when direction in 68..112 -> "W "
      direction when direction in 113..157 -> "SW"
      direction when direction in 158..203 -> "S "
      direction when direction in 204..248 -> "SE"
      direction when direction in 249..292 -> "E "
      direction when direction in 293..337 -> "NE"
      direction when direction in 338..360 -> "N "
      _ -> "N/A"
    end
  end

  defp overview(forecast) do
    Map.get(%{
      "clear-day" => "#{IO.ANSI.yellow} ☀ #{IO.ANSI.default_color}",
      "clear-night" => "#{IO.ANSI.white} ☾ #{IO.ANSI.default_color}",
      "rain" => "#{IO.ANSI.blue} ☂ #{IO.ANSI.default_color}",
      "snow" => "#{IO.ANSI.light_blue} ❄ #{IO.ANSI.default_color}",
      "sleet" => "#{IO.ANSI.light_white} ❅ #{IO.ANSI.default_color}",
      "wind" => "#{IO.ANSI.light_white} ↝ #{IO.ANSI.default_color}",
      "fog" => "#{IO.ANSI.color(240)} ☲ #{IO.ANSI.default_color}",
      "cloudy" => "#{IO.ANSI.color(240)} ☁ #{IO.ANSI.default_color}",
      "partly-cloudy-day" => "#{IO.ANSI.color(240)}☁ #{IO.ANSI.yellow}☀#{IO.ANSI.default_color}",
      "partly-cloudy-night" => "#{IO.ANSI.color(240)}☁ #{IO.ANSI.white}☾#{IO.ANSI.default_color}",
    }, forecast["icon"])
  end

  defp hilo(forecast) do
    "#{temperature(forecast["temperatureHigh"])} / #{temperature(forecast["temperatureLow"])}"
  end

  defp wind(forecast) do
    "#{wind_direction(forecast["windBearing"])} #{Float.ceil(forecast["windSpeed"] / 1)}"
  end

  defp temperature(value) do
    "#{trunc(Float.ceil(value / 1))}°"
  end

  defp day_name(time) do
    %{
      1 => "Monday:    ",
      2 => "Tuesday:   ",
      3 => "Wednesday: ",
      4 => "Thursday:  ",
      5 => "Friday:    ",
      6 => "Saturday:  ",
      7 => "Sunday:    ",
    }[Date.day_of_week(DateTime.from_unix!(time))]
  end
end
