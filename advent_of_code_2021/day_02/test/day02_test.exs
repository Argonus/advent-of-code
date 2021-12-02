defmodule Day02Test do
  use ExUnit.Case
  doctest Day02

  @example_path Path.expand("./fixtures/example.txt", __DIR__)
  @input_path Path.expand("./fixtures/input.txt", __DIR__)

  describe "part_one/1" do
    test "returns example result" do
      assert 150 == Day02.part_one(@example_path)
    end

    test "returns input result" do
      assert 1_938_402 == Day02.part_one(@input_path)
    end
  end

  describe "part_two/1" do
    test "returns example result" do
      assert 900 == Day02.part_two(@example_path)
    end

    test "returns input result" do
      assert 1_947_878_632 == Day02.part_two(@input_path)
    end
  end
end
