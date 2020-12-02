defmodule AdventOfCode2020.Day2.PartOneTest do
  use ExUnit.Case, async: true

  alias AdventOfCode2020.Day2.PartOne

  describe "find/1" do
    test "returns number of valid passwords" do
      file_path = Path.expand("../fixtures/day_2/input.txt", __DIR__)

      assert 454 == PartOne.find(file_path)
    end
  end
end
