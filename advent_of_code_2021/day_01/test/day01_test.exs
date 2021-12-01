defmodule Day01Test do
  use ExUnit.Case
  doctest Day01

  @example_path Path.expand("./fixtures/example.txt", __DIR__)
  @input_path Path.expand("./fixtures/input.txt", __DIR__)

  describe "part_one/1" do
    test "returns example result" do
      assert 7 == Day01.part_one(@example_path)
    end

    test "returns input result" do
      assert 1681 == Day01.part_one(@input_path)
    end
  end

  describe "part_two/1" do
    test "returns example result" do
      assert 5 == Day01.part_two(@example_path)
    end

    test "returns input result" do
      assert 1704 == Day01.part_two(@input_path)
    end
  end
end
