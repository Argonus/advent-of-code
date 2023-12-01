defmodule Day08Test do
  use ExUnit.Case, async: true

  @example_path Path.expand("./fixtures/example.txt", __DIR__)
  @input_path Path.expand("./fixtures/input.txt", __DIR__)

  describe "part_one/1" do
    test "example input" do
      assert 21 == Day08.part_one(@example_path)
    end

    test "personal input" do
      assert 1_807 == Day08.part_one(@input_path)
    end
  end

  describe "part_two/1" do
    test "example input" do
      assert 8 == Day08.part_two(@example_path)
    end

    test "personal input" do
      assert 480_000 == Day08.part_two(@input_path)
    end
  end
end
