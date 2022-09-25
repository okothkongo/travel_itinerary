defmodule TravelItineraryTest do
  use ExUnit.Case
  doctest TravelItinerary

  test "create_output_file/2 generates expected output" do
    TravelItinerary.create_output_file("test/support/input.txt", "test/support/output.txt")
    assert File.read!("test/support/output.txt") == File.read!("test/support/expected_ouput.txt")
  end
end
