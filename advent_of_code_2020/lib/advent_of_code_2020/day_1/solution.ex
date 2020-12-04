defmodule AdventOfCode2020.Day1.Solution do
  @moduledoc """
  --- Day 1: Report Repair ---
  After saving Christmas five years in a row, you've decided to take a vacation at a nice resort on a tropical island. Surely, Christmas will go on without you.

  The tropical island has its own currency and is entirely cash-only. The gold coins used there have a little picture of a starfish; the locals just call them stars. None of the currency exchanges seem to have heard of them, but somehow, you'll need to find fifty of these coins by the time you arrive so you can pay the deposit on your room.

  To save your vacation, you need to get all fifty stars by December 25th.

  Collect stars by solving puzzles. Two puzzles will be made available on each day in the Advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!

  Before you leave, the Elves in accounting just need you to fix your expense report (your puzzle input); apparently, something isn't quite adding up.
  """
  import AdventOfCode2020.Day1.Combinations

  @year 2020

  @type file_path :: String.t()

  @spec part_one(file_path) :: integer
  def part_one(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&to_integer/1)
    |> Enum.into(%{}, &{&1, true})
    |> find_pair()
  catch
    {el1, el2} -> el1 * el2
  end

  defp to_integer(string) do
    string
    |> String.trim()
    |> String.to_integer()
  end

  defp find_pair(values_map) do
    Enum.each(values_map, fn {value, true} ->
      lookup_elem = @year - value
      if Map.get(values_map, lookup_elem), do: throw({value, lookup_elem}), else: nil
    end)
  end

  @combine_number 3

  @spec part_two(file_path) :: integer
  def part_two(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&to_integer/1)
    |> Enum.to_list()
    |> combine(@combine_number)
    |> find_trio()
  catch
    {el1, el2, el3} -> el1 * el2 * el3
  end

  defp find_trio([head | tail]) do
    [el1, el2, el3] = head

    if el1 + el2 + el3 == @year do
      throw({el1, el2, el3})
    else
      find_trio(tail)
    end
  end
end
