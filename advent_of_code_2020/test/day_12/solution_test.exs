defmodule AdventOfCode2020.Day12.SolutionTest do
  use ExUnit.Case, async: true

  alias AdventOfCode2020.Day12.Solution

  @file_path Path.expand("../fixtures/day_12/input.txt", __DIR__)

  describe "part_one/1" do
    test "returns result for puzzle input" do
      assert 1177 == Solution.part_one(@file_path)
    end
  end

  describe "part_two/1" do
    test "returns result for puzzle input" do
      assert 46_530 == Solution.part_two(@file_path)
    end
  end
end
