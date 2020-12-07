defmodule AdventOfCode2020.Day7.SolutionTest do
  use ExUnit.Case, async: true

  alias AdventOfCode2020.Day7.Solution

  @file_path Path.expand("../fixtures/day_7/input.txt", __DIR__)

  describe "part_one/1" do
    test "returns result for puzzle input" do
      assert 337 == Solution.part_one(@file_path)
    end
  end

  describe "part_two/1" do
    test "returns result for puzzle input" do
      assert 50_100 == Solution.part_two(@file_path)
    end
  end
end
