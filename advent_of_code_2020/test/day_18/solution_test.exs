defmodule AdventOfCode2020.Day18.SolutionTest do
  use ExUnit.Case, async: true

  alias AdventOfCode2020.Day18.Solution

  @file_path Path.expand("../fixtures/day_18/input.txt", __DIR__)

  describe "part_one/1" do
    test "returns result for puzzle input" do
      assert 209_335_026_987 == Solution.part_one(@file_path)
    end
  end

  describe "part_two/1" do
    test "returns result for puzzle input" do
      assert 33_331_817_392_479 == Solution.part_two(@file_path)
    end
  end
end
