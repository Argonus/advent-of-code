defmodule Day03 do
  @moduledoc """
  Documentation for `Day03`.
  """
  @lowercase for(n <- ?a..?z, do: <<n::utf8>>)
             |> Enum.with_index(fn el, idx -> {el, idx + 1} end)
             |> Enum.into(%{})

  @uppercase for(n <- ?A..?Z, do: <<n::utf8>>)
             |> Enum.with_index(fn el, idx -> {el, idx + 27} end)
             |> Enum.into(%{})

  @letters Map.merge(@lowercase, @uppercase)

  @spec part_one(String.t()) :: integer
  def part_one(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&parse_line/1)
    |> Stream.map(&split_in_half/1)
    |> Stream.map(&find_common_element/1)
    |> Enum.reduce(0, &calculate_priority/2)
  end

  defp split_in_half(list) do
    len = round(length(list) / 2)
    Enum.split(list, len) |> Tuple.to_list()
  end

  defp find_common_element(lists) do
    lists
    |> Enum.map(&MapSet.new(&1))
    |> Enum.reduce(nil, &reduce_sets/2)
    |> MapSet.to_list()
    |> List.first()
  end

  defp reduce_sets(set, nil), do: set
  defp reduce_sets(set1, set2), do: MapSet.intersection(set1, set2)

  defp calculate_priority(elem, acc) do
    acc + Map.fetch!(@letters, elem)
  end

  @spec part_two(String.t()) :: integer
  def part_two(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&parse_line/1)
    |> Stream.chunk_every(3)
    |> Stream.map(&find_common_element/1)
    |> Enum.reduce(0, &calculate_priority/2)
  end

  ### Helper Functions
  defp parse_line(line) do
    char_list = line |> String.trim() |> String.codepoints()
  end
end
