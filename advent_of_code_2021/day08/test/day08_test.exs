defmodule Day08Test do
  use ExUnit.Case

  @example_path Path.expand("./fixtures/example.txt", __DIR__)
  @input_path Path.expand("./fixtures/input.txt", __DIR__)

  describe "part_one/1" do
    test "returns example result" do
      assert 26 == Day08.part_one(@example_path)
    end

    test "returns input result" do
      assert 383 == Day08.part_one(@input_path)
    end
  end

  describe "part_two/1" do
    test "returns example result" do
      assert 61_229 == Day08.part_two(@example_path)
    end

    test "returns input result" do
      assert 998_900 == Day08.part_two(@input_path)
    end
  end
end
