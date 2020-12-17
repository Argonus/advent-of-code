defmodule AdventOfCode2020.Day16.SolutionTest do
  use ExUnit.Case, async: true

  alias AdventOfCode2020.Day16.Solution

  @file_path Path.expand("../fixtures/day_16/input.txt", __DIR__)

  describe "part_one/1" do
    test "returns result for puzzle input" do
      assert 21_956 == Solution.part_one(@file_path)
    end
  end

  describe "part_two/1" do
    test "returns result for puzzle input" do
      assert 3_709_435_214_239 == Solution.part_two(@file_path)
    end
  end
end
