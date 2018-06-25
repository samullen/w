defmodule CLITest do
  use ExUnit.Case

  doctest W

  import W.CLI, only: [ parse_args: 1 ]

  describe "parse_args/1" do
    test "prints out the usage and exits" do
      # assert parse_args(["-h", "anything"]) == :normal
      # assert parse_args(["--help", "anything"]) == :normal
    end

    test "returns the provided location if given" do
      assert parse_args(["66226"]) == "66226"
      assert parse_args(["210 Jones Ave, Crawfordsville IN"]) == "210 Jones Ave, Crawfordsville IN"
    end

    test "returns nil if nothing is provided" do
      assert parse_args([]) == nil
    end
  end
end
