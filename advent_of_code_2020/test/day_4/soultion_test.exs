defmodule AdventOfCode2020.Day4.SolutionTest do
  use ExUnit.Case, async: true

  alias AdventOfCode2020.Day4.Solution

  @file_path Path.expand("../fixtures/day_4/input.txt", __DIR__)

  describe "part_one/1" do
    test "returns number of trees in given path" do
      assert 237 == Solution.part_one(@file_path)
    end
  end

  describe "part_two/1" do
    test "returns number of trees in given path" do
      assert 172 == Solution.part_two(@file_path)
    end
  end
end
