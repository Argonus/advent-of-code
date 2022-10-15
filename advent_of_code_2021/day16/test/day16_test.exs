defmodule Day16Test do
  use ExUnit.Case

  @p1_example_1_path Path.expand("./fixtures/part_one/example_1.txt", __DIR__)
  @p1_example_2_path Path.expand("./fixtures/part_one/example_2.txt", __DIR__)
  @p1_example_3_path Path.expand("./fixtures/part_one/example_3.txt", __DIR__)
  @p1_example_4_path Path.expand("./fixtures/part_one/example_4.txt", __DIR__)

  @p2_example_1_path Path.expand("./fixtures/part_two/example_1.txt", __DIR__)
  @p2_example_2_path Path.expand("./fixtures/part_two/example_2.txt", __DIR__)
  @p2_example_3_path Path.expand("./fixtures/part_two/example_3.txt", __DIR__)
  @p2_example_4_path Path.expand("./fixtures/part_two/example_4.txt", __DIR__)
  @p2_example_5_path Path.expand("./fixtures/part_two/example_5.txt", __DIR__)
  @p2_example_6_path Path.expand("./fixtures/part_two/example_6.txt", __DIR__)
  @p2_example_7_path Path.expand("./fixtures/part_two/example_7.txt", __DIR__)
  @p2_example_8_path Path.expand("./fixtures/part_two/example_8.txt", __DIR__)

  @input_path Path.expand("./fixtures/input.txt", __DIR__)

  describe "part_one/1" do
    test "returns example result - example 1" do
      assert 16 == Day16.part_one(@p1_example_1_path)
    end

    test "returns example result - example 2" do
      assert 12 == Day16.part_one(@p1_example_2_path)
    end

    test "returns example result - example 3" do
      assert 23 == Day16.part_one(@p1_example_3_path)
    end

    test "returns example result - example 4" do
      assert 31 == Day16.part_one(@p1_example_4_path)
    end

    test "returns input result" do
      assert 897 == Day16.part_one(@input_path)
    end
  end

  describe "part_two/1" do
    test "returns example result - example 1" do
      assert 3 == Day16.part_two(@p2_example_1_path)
    end

    test "returns example result - example 2" do
      assert 54 == Day16.part_two(@p2_example_2_path)
    end

    test "returns example result - example 3" do
      assert 7 == Day16.part_two(@p2_example_3_path)
    end

    test "returns example result - example 4" do
      assert 9 == Day16.part_two(@p2_example_4_path)
    end

    test "returns example result - example 5" do
      assert 1 == Day16.part_two(@p2_example_5_path)
    end

    test "returns example result - example 6" do
      assert 0 == Day16.part_two(@p2_example_6_path)
    end

    test "returns example result - example 7" do
      assert 0 == Day16.part_two(@p2_example_7_path)
    end

    test "returns example result - example 8" do
      assert 1 == Day16.part_two(@p2_example_8_path)
    end

    test "returns input result" do
      assert 9485076995911 == Day16.part_two(@input_path)
    end
  end
end
