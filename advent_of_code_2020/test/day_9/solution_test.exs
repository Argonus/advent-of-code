defmodule AdventOfCode2020.Day9.SolutionTest do
  use ExUnit.Case, async: true

  alias AdventOfCode2020.Day9.Solution

  @file_path Path.expand("../fixtures/day_9/input.txt", __DIR__)

  describe "part_one/1" do
    test "returns result for puzzle input" do
      assert 507_622_668 == Solution.part_one(@file_path)
    end
  end

  describe "part_two/1" do
    test "returns result for puzzle input" do
      assert 76_688_505 == Solution.part_two(@file_path)
    end
  end
end
