defmodule Day10Test do
  use ExUnit.Case, async: true

  @example_path Path.expand("./fixtures/example.txt", __DIR__)
  @input_path Path.expand("./fixtures/input.txt", __DIR__)

  describe "part_one/1" do
    test "example input" do
      assert 13_140 == Day10.part_one(@example_path)
    end

    test "personal input" do
      assert 13_680 == Day10.part_one(@input_path)
    end
  end

  describe "part_two/1" do
    test "example input one" do
      assert 1 == Day10.part_two(@example_path)
    end

    test "personal input" do
      assert 2765 == Day10.part_two(@input_path)
    end
  end
end
