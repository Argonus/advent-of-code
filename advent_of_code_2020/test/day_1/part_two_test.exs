defmodule AdventOfCode2020.Day1.PartTwoTest do
  use ExUnit.Case, async: true

  alias AdventOfCode2020.Day1.PartTwo

  describe "find/1" do
    test "returns error tuple when no result found with" do
      file_path = Path.expand("../fixtures/day_1/no_result.txt", __DIR__)

      assert {:error, :not_found} == PartTwo.find(file_path)
    end

    test "returns tuple with answer when one result found" do
      file_path = Path.expand("../fixtures/day_1/one_result.txt", __DIR__)

      assert {:ok, [{272_611_658, {523, 551, 946}}]} == PartTwo.find(file_path)
    end

    test "returns tuple with answer when more than one result found" do
      file_path = Path.expand("../fixtures/day_1/multiple_results.txt", __DIR__)

      assert {:ok,
              [
                {76_703_760, {90, 684, 1246}},
                {294_638_136, {533, 743, 744}}
              ]} ==
               PartTwo.find(file_path)
    end
  end
end
