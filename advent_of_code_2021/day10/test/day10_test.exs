defmodule Day10Test do
  use ExUnit.Case

  @example_path Path.expand("./fixtures/example.txt", __DIR__)
  @input_path Path.expand("./fixtures/input.txt", __DIR__)

  describe "part_one/1" do
    test "returns example result" do
      assert 26397 == Day10.part_one(@example_path)
    end

    test "returns input result" do
      assert 436_497 == Day10.part_one(@input_path)
    end
  end

  describe "part_two/1" do
    test "returns example result" do
      assert 288_957 == Day10.part_two(@example_path)
    end

    test "returns input result" do
      assert 2_377_613_374 == Day10.part_two(@input_path)
    end
  end
end
