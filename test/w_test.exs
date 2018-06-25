defmodule WTest do
  use ExUnit.Case
  doctest W

  test "greets the world" do
    assert W.hello() == :world
  end
end
