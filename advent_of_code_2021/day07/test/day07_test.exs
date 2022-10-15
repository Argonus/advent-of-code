defmodule Day07Test do
  use ExUnit.Case

  @example_path Path.expand("./fixtures/example.txt", __DIR__)
  @input_path Path.expand("./fixtures/input.txt", __DIR__)

  describe "part_one/1" do
    test "returns example result" do
      assert 37 == Day07.part_one(@example_path)
    end

    test "returns input result" do
      assert 336_131 == Day07.part_one(@input_path)
    end
  end

  describe "part_two/1" do
    test "returns example result" do
      assert 168 == Day07.part_two(@example_path)
    end

    test "returns input result" do
      assert 92_676_646 == Day07.part_two(@input_path)
    end
  end
end
