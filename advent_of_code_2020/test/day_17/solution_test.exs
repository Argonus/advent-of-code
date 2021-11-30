defmodule AdventOfCode2020.Day17.SolutionTest do
  use ExUnit.Case, async: true

  alias AdventOfCode2020.Day17.Solution

  @file_path Path.expand("../fixtures/day_17/input.txt", __DIR__)

  describe "part_one/1" do
    @tag skip: true
    test "returns result for puzzle input" do
      assert 386 == Solution.part_one(@file_path)
    end
  end

  describe "part_two/1" do
    @tag skip: true
    test "returns result for puzzle input" do
      assert nil == Solution.part_two(@file_path)
    end
  end
end
