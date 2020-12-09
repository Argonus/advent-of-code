defmodule AdventOfCode2020.Day9.Solution do
  @moduledoc """
  With your neighbor happily enjoying their video game, you turn your attention to an open data port on the little screen in the seat in front of you.

  Though the port is non-standard, you manage to connect it to your computer through the clever use of several paperclips. Upon connection, the port outputs a series of numbers (your puzzle input).

  The data appears to be encrypted with the eXchange-Masking Addition System (XMAS) which, conveniently for you, is an old cypher with an important weakness.

  XMAS starts by transmitting a preamble of 25 numbers. After that, each number you receive should be the sum of any two of the 25 immediately previous numbers. The two numbers will have different values, and there might be more than one such pair.

  For example, suppose your preamble consists of the numbers 1 through 25 in a random order. To be valid, the next number must be the sum of two of those numbers:

  26 would be a valid next number, as it could be 1 plus 25 (or many other pairs, like 2 and 24).
  49 would be a valid next number, as it is the sum of 24 and 25.
  100 would not be valid; no two of the previous 25 numbers sum to 100.
  50 would also not be valid; although 25 appears in the previous 25 numbers, the two numbers in the pair must be different.

  Suppose the 26th number is 45, and the first number (no longer an option, as it is more than 25 numbers ago) was 20. Now, for the next number to be valid, there needs to be some pair of numbers among 1-19, 21-25, or 45 that add up to it:

  26 would still be a valid next number, as 1 and 25 are still within the previous 25 numbers.
  65 would not be valid, as no two of the available numbers sum to it.
  64 and 66 would both be valid, as they are the result of 19+45 and 21+45 respectively.
  """
  @type file_path :: String.t()

  @doc """
  The first step of attacking the weakness in the XMAS data is to find the first number in the list (after the preamble) which is not the sum of two of the 25 numbers before it. What is the first number that does not have this property?
  """
  @preamble 25
  @spec part_one(file_path) :: integer
  def part_one(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&parse_line/1)
    |> Enum.reduce([], &find_invalid_elem/2)
  catch
    elem -> elem
  end

  defp parse_line(line), do: line |> String.trim() |> String.to_integer()

  defp find_invalid_elem(elem, acc) do
    case check_elem_is_valid(elem, acc) do
      {:ok, new_acc} -> new_acc
      {:error, elem} -> throw(elem)
    end
  end

  defp check_elem_is_valid(elem, acc) when length(acc) < @preamble, do: {:ok, [elem | acc]}

  defp check_elem_is_valid(elem, acc) do
    if is_summing_number_present?(acc, elem) do
      {_, list} = List.pop_at(acc, -1)
      {:ok, [elem | list]}
    else
      {:error, elem}
    end
  end

  defp is_summing_number_present?([], _), do: false

  defp is_summing_number_present?([head | tail], elem) do
    look_for = elem - head
    if Enum.member?(tail, look_for), do: true, else: is_summing_number_present?(tail, elem)
  end

  @doc """
  The final step in breaking the XMAS encryption relies on the invalid number you just found: you must find a contiguous set of at least two numbers in your list which sum to the invalid number from step 1.

  In this list, adding up all of the numbers from 15 through 40 produces the invalid number from step 1, 127. (Of course, the contiguous set of numbers in your actual list might be much longer.)

  To find the encryption weakness, add together the smallest and largest number in this contiguous range; in this example, these are 15 and 47, producing 62.

  What is the encryption weakness in your XMAS-encrypted list of numbers?
  """
  @spec part_two(file_path) :: integer
  def part_two(file_path) do
    target = part_one(file_path)
    list_of_numbers = file_path |> File.stream!() |> Stream.map(&parse_line/1) |> Enum.to_list()

    find_contiguous_numbers(target, list_of_numbers)
  end

  defp find_contiguous_numbers(target, [head | tail]) do
    case do_find_contiguous_numbers(target, [head], tail) do
      {:error, _} -> find_contiguous_numbers(target, tail)
      {:ok, range} -> Enum.min(range) + Enum.max(range)
    end
  end

  defp do_find_contiguous_numbers(target, numbers, [head | tail]) do
    new_numbers = [head | numbers]

    case Enum.sum(new_numbers) do
      # Sum is bigger than target, we can start with new set of numbers
      sum when sum > target -> {:error, :not_found}
      # Sum is smaller than target, we can add one more number for numbers
      sum when sum < target -> do_find_contiguous_numbers(target, new_numbers, tail)
      # We have found our numbers. Returns range and stop loop
      sum when sum === target -> {:ok, new_numbers}
    end
  end
end
