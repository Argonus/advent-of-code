defmodule AdventOfCode2020.Day1.CombinationsTest do
  use ExUnit.Case, async: true

  alias AdventOfCode2020.Day1.Combinations

  describe "combine/2" do
    test "returns list of combinations for combination = 0" do
      list = [1, 2, 3]

      assert [[]] == Combinations.combine(list, 0)
    end

    test "returns list of combinations for combination = 1" do
      list = [1, 2, 3]

      assert [[1], [2], [3]] == Combinations.combine(list, 1)
    end

    test "returns list of combinations for combination = 2" do
      list = [1, 2, 3]

      assert [[3, 2], [3, 1], [2, 1]] == Combinations.combine(list, 2)
    end
  end
end
