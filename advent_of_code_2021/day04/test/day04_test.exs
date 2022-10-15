defmodule Day04Test do
  use ExUnit.Case
  doctest Day04

  @example_path Path.expand("./fixtures/example.txt", __DIR__)
  @input_path Path.expand("./fixtures/input.txt", __DIR__)

  describe "part_one/1" do
    test "returns example result" do
      assert 4512 == Day04.part_one(@example_path)
    end

    test "returns input result" do
      assert 58_838 == Day04.part_one(@input_path)
    end
  end

  describe "part_two/1" do
    test "returns example result" do
      assert 1924 == Day04.part_two(@example_path)
    end

    test "returns input result" do
      assert 6256 == Day04.part_two(@input_path)
    end
  end
end
