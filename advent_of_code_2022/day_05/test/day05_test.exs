defmodule Day05Test do
  use ExUnit.Case, async: true

  @example_path Path.expand("./fixtures/example.txt", __DIR__)
  @input_path Path.expand("./fixtures/input.txt", __DIR__)

  describe "part_one/1" do
    test "example input" do
      assert "CMZ" == Day05.part_one(@example_path)
    end

    test "personal input" do
      assert "QNHWJVJZW" == Day05.part_one(@input_path)
    end
  end

  describe "part_two/1" do
    test "example input" do
      assert "MCD" == Day05.part_two(@example_path)
    end

    test "personal input" do
      assert "BPCZJLFJW" == Day05.part_two(@input_path)
    end
  end
end
