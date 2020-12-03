defmodule AdventOfCode2020.Day1.SolutionTest do
  use ExUnit.Case, async: true

  alias AdventOfCode2020.Day1.Solution

  @file_path Path.expand("../fixtures/day_1/input.txt", __DIR__)
  describe "part_one/1" do
    test "returns multiplication of two values which sum is == 2020" do
      assert 468_051 == Solution.part_one(@file_path)
    end
  end

  describe "part_two/1" do
    test "returns multiplication of three values which sum is == 2020" do
      assert 272_611_658 == Solution.part_two(@file_path)
    end
  end
end
