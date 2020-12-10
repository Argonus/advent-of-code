defmodule AdventOfCode2020.Day10.SolutionTest do
  use ExUnit.Case, async: true

  alias AdventOfCode2020.Day10.Solution

  @file_path Path.expand("../fixtures/day_10/input.txt", __DIR__)

  describe "part_one/1" do
    test "returns result for puzzle input" do
      assert 2_210 == Solution.part_one(@file_path)
    end
  end

  describe "part_two/1" do
    test "returns result for puzzle input" do
      assert 7_086_739_046_912 == Solution.part_two(@file_path)
    end
  end
end
