defmodule W.CLI do
  def run(argv) do
    argv
    |> parse_args
    |> retrieve_lat_long
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean ],
                               aliases: [ h: :help ])

    case parse do
      { [ help: true ], _, _ } ->
        usage()
        exit(:normal)

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

  def retrieve_lat_long(location) do
    IO.puts location
  end
end
