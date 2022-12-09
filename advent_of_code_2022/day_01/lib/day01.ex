defmodule Day01 do
  @moduledoc """
  Documentation for `Day01`.
  """
  @chunk_separator ""

  @spec part_one(String.t()) :: integer
  def part_one(file_path) do
    file_path
    |> File.stream!()
    |> sum_calories()
    |> Enum.max()
  end

  defp sum_calories(file_stream) do
    file_stream
    |> Stream.map(&String.trim/1)
    |> Stream.chunk_by(&(&1 == @chunk_separator))
    |> Stream.reject(&(&1 == [""]))
    |> Stream.map(&sum_chunk/1)
  end

  defp sum_chunk(chunk) do
    chunk
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  @spec part_two(String.t()) :: integer
  def part_two(file_path) do
    file_path
    |> File.stream!()
    |> sum_calories()
    |> Enum.reduce([], &reducer/2)
    |> Enum.sum()
  end

  defp reducer(el, acc) do
    [el | acc] |> Enum.sort(:desc) |> Enum.take(3)
  end
end
