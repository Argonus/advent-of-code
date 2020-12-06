defmodule AdventOfCode2020.Day5.Solution do
  @moduledoc """
  You board your plane only to discover a new problem: you dropped your boarding pass! You aren't sure which seat is yours, and all of the flight attendants are busy with the flood of people that suddenly made it through passport control.

  You write a quick program to use your phone's camera to scan all of the nearby boarding passes (your puzzle input); perhaps you can find your seat through process of elimination.

  Instead of zones or groups, this airline uses binary space partitioning to seat people. A seat might be specified like FBFBBFFRLR, where F means "front", B means "back", L means "left", and R means "right".

  The first 7 characters will either be F or B; these specify exactly one of the 128 rows on the plane (numbered 0 through 127). Each letter tells you which half of a region the given seat is in. Start with the whole list of rows; the first letter indicates whether the seat is in the front (0 through 63) or the back (64 through 127). The next letter indicates which half of that region the seat is in, and so on until you're left with exactly one row.

  For example, consider just the first seven characters of FBFBBFFRLR:

  Start by considering the whole range, rows 0 through 127.
  F means to take the lower half, keeping rows 0 through 63.
  B means to take the upper half, keeping rows 32 through 63.
  F means to take the lower half, keeping rows 32 through 47.
  B means to take the upper half, keeping rows 40 through 47.
  B keeps rows 44 through 47.
  F keeps rows 44 through 45.
  The final F keeps the lower of the two, row 44.

  The last three characters will be either L or R; these specify exactly one of the 8 columns of seats on the plane (numbered 0 through 7). The same process as above proceeds again, this time with only three steps. L means to keep the lower half, while R means to keep the upper half.

  For example, consider just the last 3 characters of FBFBBFFRLR:

  Start by considering the whole range, columns 0 through 7.
  R means to take the upper half, keeping columns 4 through 7.
  L means to take the lower half, keeping columns 4 through 5.
  The final R keeps the upper of the two, column 5.

  So, decoding FBFBBFFRLR reveals that it is the seat at row 44, column 5.

  Every seat also has a unique seat ID: multiply the row by 8, then add the column. In this example, the seat has ID 44 * 8 + 5 = 357.
  """

  @type file_path :: String.t()

  @row_min 0
  @row_max 128

  @column_min 0
  @column_max 8

  @lower_row "F"
  @upper_row "B"

  @lower_column "L"
  @upper_column "R"

  @seat_regex ~r/((?:F|B){7})((?:R|L){3})/

  @doc """
  As a sanity check, look through your list of boarding passes. What is the highest seat ID on a boarding pass?
  """
  @spec part_one(file_path) :: integer
  def part_one(file_path) do
    file_path
    |> seats_to_ids_stream()
    |> Enum.max()
  end

  defp seats_to_ids_stream(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&String.trim(&1))
    |> Stream.map(&seat_line_to_list/1)
    |> Stream.map(&seat_to_id/1)
  end

  defp seat_line_to_list(seat_line) do
    @seat_regex
    |> Regex.run(seat_line, capture: :all_but_first)
    |> Enum.map(&String.graphemes(&1))
  end

  defp seat_to_id([row, column]) do
    row = find_seat(row, @row_min, @row_max, 0, @lower_row, @upper_row, 7)
    column = find_seat(column, @column_min, @column_max, 0, @lower_column, @upper_column, 3)

    row * 8 + column
  end

  defp find_seat([lower | tail], min, max, n, lower, upper, max_n) when n < max_n do
    new_max = (max - min) / 2 + min
    find_seat(tail, min, new_max, n + 1, lower, upper, max_n)
  end

  defp find_seat([upper | tail], min, max, n, lower, upper, max_n) when n < max_n do
    new_min = (max - min) / 2 + min
    find_seat(tail, new_min, max, n + 1, lower, upper, max_n)
  end

  defp find_seat(_, min, max, _, _, _, _), do: Kernel.min(min, max - 1)

  @spec part_two(file_path) :: integer
  def part_two(file_path) do
    sorted_seat_ids = file_path |> seats_to_ids_stream() |> Enum.sort()
    seats_number = length(sorted_seat_ids)

    sorted_seat_ids
    |> Enum.with_index()
    |> Enum.take(seats_number - 1)
    |> Enum.filter(fn {seat_id, idx} ->
      seat_id - Enum.at(sorted_seat_ids, idx + 1) != -1
    end)
    |> Enum.map(fn {seat_id, _} ->
      seat_id + 1
    end)
    |> parse_output()
  end

  defp parse_output([el]), do: el
end
