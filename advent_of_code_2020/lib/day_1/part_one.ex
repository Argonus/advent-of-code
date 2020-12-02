defmodule AdventOfCode2020.Day1.PartOne do
  @moduledoc """
  --- Day 1: Report Repair ---
  After saving Christmas five years in a row, you've decided to take a vacation at a nice resort on a tropical island. Surely, Christmas will go on without you.

  The tropical island has its own currency and is entirely cash-only. The gold coins used there have a little picture of a starfish; the locals just call them stars. None of the currency exchanges seem to have heard of them, but somehow, you'll need to find fifty of these coins by the time you arrive so you can pay the deposit on your room.

  To save your vacation, you need to get all fifty stars by December 25th.

  Collect stars by solving puzzles. Two puzzles will be made available on each day in the Advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!

  Before you leave, the Elves in accounting just need you to fix your expense report (your puzzle input); apparently, something isn't quite adding up.

  Specifically, they need you to find the two entries that sum to 2020 and then multiply those two numbers together.
  """
  import AdventOfCode2020.Day1.FileHelpers

  @year 2020

  @type file_path :: String.t()
  @type result :: {integer, {integer, integer}}

  @spec find(String.t()) :: {:ok, [result]} | {:error, :not_found}
  def find(file_path) do
    file_path
    |> parse_file()
    |> find_pair([])
    |> parse_result()
  end

  defp find_pair([], acc), do: acc

  defp find_pair([head | tail], acc) do
    results = Enum.filter(tail, &(head + &1 == @year)) |> Enum.map(&{head, &1})
    find_pair(tail, acc ++ results)
  end

  defp parse_result([]), do: {:error, :not_found}

  defp parse_result(results) do
    results =
      Enum.map(results, fn set = {el1, el2} ->
        {el1 * el2, set}
      end)

    {:ok, results}
  end
end
