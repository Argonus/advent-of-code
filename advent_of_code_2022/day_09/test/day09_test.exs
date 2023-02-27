defmodule Day09Test do
  use ExUnit.Case, async: true

  @example_path_one Path.expand("./fixtures/example.txt", __DIR__)
  @example_path_two Path.expand("./fixtures/example_two.txt", __DIR__)
  @input_path Path.expand("./fixtures/input.txt", __DIR__)

  describe "part_one/1" do
    test "example input" do
      assert 13 == Day09.part_one(@example_path_one)
    end

    test "personal input" do
      assert 6_642 == Day09.part_one(@input_path)
    end
  end

  describe "part_two/1" do
    test "example input one" do
      assert 1 == Day09.part_two(@example_path_one)
    end

    test "example input two" do
      assert 36 == Day09.part_two(@example_path_two)
    end

    test "personal input" do
      assert 2765 == Day09.part_two(@input_path)
    end
  end
end
