defmodule Day11Test do
  use ExUnit.Case, async: true

  @example_path Path.expand("./fixtures/example.txt", __DIR__)
  @input_path Path.expand("./fixtures/input.txt", __DIR__)

  describe "part_one/1" do
    test "example input" do
      assert 10_605 == Day11.part_one(@example_path)
    end

    test "personal input" do
      assert 100_345 == Day11.part_one(@input_path)
    end
  end

  describe "part_two/1" do
    test "example input" do
      assert 2_713_310_158 == Day11.part_two(@example_path)
    end

    test "personal input" do
      assert 28_537_348_205 == Day11.part_two(@input_path)
    end
  end
end
