defmodule Day03 do
  @moduledoc """
  The submarine has been making some odd creaking noises, so you ask it to produce a diagnostic report just in case.

  The diagnostic report (your puzzle input) consists of a list of binary numbers which, when decoded properly,
  can tell you many useful things about the conditions of the submarine.
  The first parameter to check is the power consumption.

  You need to use the binary numbers in the diagnostic report to generate two new binary numbers (called the gamma rate and the epsilon rate).
  The power consumption can then be found by multiplying the gamma rate by the epsilon rate.

  Each bit in the gamma rate can be determined by finding the most common bit in the
  corresponding position of all numbers in the diagnostic report. For example, given the following diagnostic report:

  00100
  11110
  10110
  10111
  10101
  01111
  00111
  11100
  10000
  11001
  00010
  01010

  Considering only the first bit of each number, there are five 0 bits and seven 1 bits.
  Since the most common bit is 1, the first bit of the gamma rate is 1.

  The most common second bit of the numbers in the diagnostic report is 0, so the second bit of the gamma rate is 0.

  The most common value of the third, fourth, and fifth bits are 1, 1, and 0, respectively, and so the final three bits of the gamma rate are 110.

  So, the gamma rate is the binary number 10110, or 22 in decimal.

  The epsilon rate is calculated in a similar way; rather than use the most common bit, the least common bit from each position is used. So, the epsilon rate is 01001, or 9 in decimal.
  Multiplying the gamma rate (22) by the epsilon rate (9) produces the power consumption, 198.
  """

  use Bitwise

  @doc """
  Use the binary numbers in your diagnostic report to calculate the gamma rate and epsilon rate, then multiply them together.
  What is the power consumption of the submarine? (Be sure to represent your answer in decimal, not binary.)
  """
  @spec part_one(String.t()) :: integer
  def part_one(file_path) do
    gamma_bits =
      file_path
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.graphemes/1)
      |> Enum.zip()
      |> Stream.map(&calculate_frequencies/1)
      |> Stream.map(&select_gamma_val/1)
      |> Enum.to_list()

    max = (1 <<< length(gamma_bits)) - 1

    gamma_val = bits_list_to_integer(gamma_bits)
    epsilon_val = max - gamma_val

    epsilon_val * gamma_val
  end

  defp calculate_frequencies(bit_vals) do
    bit_vals
    |> Tuple.to_list()
    |> Enum.frequencies()
  end

  defp select_gamma_val(bit_vals) do
    bit_vals |> Enum.max_by(fn {_k, v} -> v end) |> elem(0)
  end

  defp bits_list_to_integer(bits) do
    bits |> Enum.join("") |> String.to_integer(2)
  end

  @doc """
  Next, you should verify the life support rating, which can be determined by multiplying the oxygen generator rating by the CO2 scrubber rating.

  Both the oxygen generator rating and the CO2 scrubber rating are values that can be found in your diagnostic report -
  finding them is the tricky part. Both values are located using a similar process that involves filtering out values until only one remains.
  Before searching for either rating value, start with the full list of binary numbers from your diagnostic report and consider just the first bit of those numbers.
  Then:

  Keep only numbers selected by the bit criteria for the type of rating value for which you are searching.
  Discard numbers which do not match the bit criteria.
  If you only have one number left, stop; this is the rating value for which you are searching.
  Otherwise, repeat the process, considering the next bit to the right.

  - To find oxygen generator rating, determine the most common value (0 or 1) in the current bit position,
    and keep only numbers with that bit in that position.
    If 0 and 1 are equally common, keep values with a 1 in the position being considered.
  - To find CO2 scrubber rating, determine the least common value (0 or 1) in the current bit position,
    and keep only numbers with that bit in that position.
    If 0 and 1 are equally common, keep values with a 0 in the position being considered.

  Finally, to find the life support rating, multiply the oxygen generator rating (23) by the CO2 scrubber rating (10) to get 230.

  Use the binary numbers in your diagnostic report to calculate the oxygen generator rating and CO2 scrubber rating, then multiply them together.
  What is the life support rating of the submarine? (Be sure to represent your answer in decimal, not binary.)
  """
  @spec part_two(String.t()) :: integer
  def part_two(file_path) do
    data_set =
      file_path
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.graphemes/1)
      |> Stream.map(&List.to_tuple/1)
      |> Enum.to_list()

    oxy = calculate_rating(data_set, 0, :o2)
    co2 = calculate_rating(data_set, 0, :co2)

    oxy * co2
  end

  defp calculate_rating([elem], _pos, _rating_type), do: elem |> Tuple.to_list() |> bits_list_to_integer()

  defp calculate_rating(data_set, pos, rating_type) do
    groups = Enum.group_by(data_set, &elem(&1, pos))
    group_zero = groups["0"] || []
    group_one = groups["1"] || []

    cond do
      length(group_zero) > length(group_one) && rating_type == :o2 ->
        calculate_rating(group_zero, pos + 1, rating_type)

      rating_type == :o2 ->
        calculate_rating(group_one, pos + 1, rating_type)

      length(group_one) < length(group_zero) && rating_type == :co2 ->
        calculate_rating(group_one, pos + 1, rating_type)

      true ->
        calculate_rating(group_zero, pos + 1, rating_type)
    end
  end
end
