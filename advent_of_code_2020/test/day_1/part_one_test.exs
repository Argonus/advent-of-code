defmodule AdventOfCode2020.Day1.PartOneTest do
  use ExUnit.Case, async: true

  alias AdventOfCode2020.Day1.PartOne

  describe "find/1" do
    test "returns error tuple when no result found with" do
      file_path = Path.expand("../fixtures/day_1/no_result.txt", __DIR__)

      assert {:error, :not_found} == PartOne.find(file_path)
    end

    test "returns tuple with answer when one result found" do
      file_path = Path.expand("../fixtures/day_1/one_result.txt", __DIR__)

      assert {:ok, [{468_051, {1753, 267}}]} == PartOne.find(file_path)
    end

    test "returns tuple with answer when more than one result found" do
      file_path = Path.expand("../fixtures/day_1/multiple_results.txt", __DIR__)

      assert {:ok, [{1_020_000, {1000, 1020}}, {1_019_956, {998, 1022}}]} ==
               PartOne.find(file_path)
    end
  end
end
