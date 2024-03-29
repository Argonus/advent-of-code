defmodule Day03Test do
  use ExUnit.Case
  doctest Day03

  @example_path Path.expand("./fixtures/example.txt", __DIR__)
  @input_path Path.expand("./fixtures/input.txt", __DIR__)

  describe "part_one/1" do
    test "returns example result" do
      assert 198 == Day03.part_one(@example_path)
    end

    test "returns input result" do
      assert 2_640_986 == Day03.part_one(@input_path)
    end
  end

  describe "part_two/1" do
    test "returns example result" do
      assert 230 == Day03.part_two(@example_path)
    end

    test "returns input result" do
      assert 6_822_109 == Day03.part_two(@input_path)
    end
  end
end
