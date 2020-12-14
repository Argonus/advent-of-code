defmodule AdventOfCode2020.Day14.SolutionTest do
  use ExUnit.Case, async: true

  alias AdventOfCode2020.Day14.Solution

  @file_path Path.expand("../fixtures/day_14/input.txt", __DIR__)

  describe "part_one/1" do
    test "returns result for puzzle input" do
      assert 10_035_335_144_067 == Solution.part_one(@file_path)
    end
  end

  describe "part_two/1" do
    test "returns result for puzzle input" do
      assert 3_817_372_618_036 == Solution.part_two(@file_path)
    end
  end
end
