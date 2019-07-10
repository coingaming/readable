defmodule ReadableTest do
  use ExUnit.Case
  doctest Readable

  test "greets the world" do
    assert Readable.hello() == :world
  end
end
