defmodule Day01Test do
  use ExUnit.Case, async: true

  @example_path Path.expand("./fixtures/example.txt", __DIR__)
  @input_path Path.expand("./fixtures/input.txt", __DIR__)

  describe "part_one/1" do
    test "example input" do
      assert 24_000 == Day01.part_one(@example_path)
    end

    test "personal input" do
      assert 70296 == Day01.part_one(@input_path)
    end
  end

  describe "part_two/1" do
    test "example input" do
      assert 45_000 == Day01.part_two(@example_path)
    end

    test "personal input" do
      assert 205_381 == Day01.part_two(@input_path)
    end
  end
end
