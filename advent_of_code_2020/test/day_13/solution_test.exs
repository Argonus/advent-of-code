defmodule AdventOfCode2020.Day13.SolutionTest do
  use ExUnit.Case, async: true

  alias AdventOfCode2020.Day13.Solution

  @file_path Path.expand("../fixtures/day_13/input.txt", __DIR__)

  describe "part_one/1" do
    test "returns result for puzzle input" do
      assert 207 == Solution.part_one(@file_path)
    end
  end

  describe "part_two/1" do
    test "returns result for puzzle input" do
      assert 530_015_546_283_687 == Solution.part_two(@file_path)
    end
  end
end
