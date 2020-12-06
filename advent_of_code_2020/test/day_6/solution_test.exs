defmodule AdventOfCode2020.Day6.SolutionTest do
  use ExUnit.Case, async: true

  alias AdventOfCode2020.Day6.Solution

  @file_path Path.expand("../fixtures/day_6/input.txt", __DIR__)

  describe "part_one/1" do
    test "returns result for puzzle input" do
      assert 6416 == Solution.part_one(@file_path)
    end
  end

  describe "part_two/2" do
    test "returns result for puzzle input" do
      assert 3050 == Solution.part_two(@file_path)
    end
  end
end
