defmodule Day04 do
  @moduledoc """
  Documentation for `Day04`.
  """
  @line_regexp ~r/^(\d+)-(\d+),(\d+)-(\d+)$/

  @doc """
  In how many pairs does one range fully contain the other?
  """
  @spec part_one(String.t()) :: integer
  def part_one(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&parse_line/1)
    |> Enum.count(fn {r1, r2} ->
        range_contains_range?(r1, r2) || range_contains_range?(r2, r1)
    end)
  end

  def range_contains_range?(range1, range2) do
    range1.first >= range2.first && range1.last <= range2.last
  end

  @doc """
  In how many pairs do the ranges overlap?
  """
  @spec part_two(String.t()) :: integer
  def part_two(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&parse_line/1)
    |> Enum.count(fn {r1, r2} ->
      !Range.disjoint?(r1, r2)
    end)
  end

  ### Helpers
  defp parse_line(line) do
    @line_regexp
    |> Regex.run(line, capture: :all_but_first)
    |> Enum.map(&String.to_integer/1)
    |> build_ranges()
  end

  defp build_ranges([b1, e1, b2, e2]) do
    {Range.new(b1, e1), Range.new(b2, e2)}
  end
end
