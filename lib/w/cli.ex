defmodule W.CLI do
  def run(argv) do
    argv
    |> parse_args
    |> process
    |> present_output
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean ],
                               aliases: [ h: :help ])

    case parse do
      { [ help: true ], _, _ } ->
        :help

      { _, [ location], _ } ->
        location

      _ -> nil
    end
  end

  def usage do
    IO.puts """
      usage: w [geolocatable info]
      """
  end

  def process(:help) do
    usage()
    System.halt(0)
  end

  def process(nil) do
    IO.puts "Get lat/lon from IP"
  end

  def process(location) do
    lat_long_from_location(location)
    |> W.DarkskyForecast.fetch
  end

  def present_output({:ok, forecast}) do
    IO.puts ""
    forecast
    |> W.Presenter.alerts
    |> W.Presenter.current_conditions
    |> W.Presenter.daily_forecast
  end

  def present_output(:error, body) do
    IO.puts body
  end

  def lat_long_from_location(location) do
    case Geocoder.call(location) do
      {:ok, coords} ->
        coords

      {:error, _} ->
        IO.puts "Unable to retrieve forecast for '#{location}'."
        System.halt(0)

      _ ->
        IO.puts "Something unexpected happend"
        System.halt(0)
    end
  end
end
