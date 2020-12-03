defmodule AdventOfCode2020.Day2.SolutionTest do
  use ExUnit.Case, async: true

  alias AdventOfCode2020.Day2.Solution

  @file_path Path.expand("../fixtures/day_2/input.txt", __DIR__)

  describe "part_one/1" do
    test "returns number of valid passwords" do
      assert 454 == Solution.part_one(@file_path)
    end
  end

  describe "part_two/1" do
    test "returns number of valid passwords" do
      assert 649 == Solution.part_two(@file_path)
    end
  end
end
