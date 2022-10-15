defmodule Day14Test do
  use ExUnit.Case

  @example_path Path.expand("./fixtures/example.txt", __DIR__)
  @input_path Path.expand("./fixtures/input.txt", __DIR__)

  describe "part_one/1" do
    test "returns example result" do
      assert 1588 == Day14.part_one(@example_path)
    end

    test "returns input result" do
      assert 2549 == Day14.part_one(@input_path)
    end
  end

  describe "part_two/1" do
    test "returns example result" do
      assert 2_188_189_693_529 == Day14.part_two(@example_path)
    end

    test "returns input result" do
      assert 2_516_901_104_210 == Day14.part_two(@input_path)
    end
  end
end
