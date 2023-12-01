defmodule Day10 do
  @moduledoc """
  Documentation for `Day10`.
  """

  @spec part_one(String.t()) :: integer
  def part_one(file_path) do
    accumulator = %{
      cycle: 0,
      value: 1,
      sum: 0
    }

    file_path
    |> parse_file()
    |> Enum.reduce(accumulator, &apply_command/2)
    |> Map.fetch!(:sum)
  end

  defp apply_command(:noop, acc = %{cycle: cycle, value: value, sum: sum}) do
    increment_cycle(acc)
  end

  defp apply_command({:addx, incr}, acc = %{cycle: cycle, value: value, sum: sum}) do
    acc
    |> increment_cycle()
    |> increment_cycle()
    |> increment_value(incr)
  end

  defp increment_value(acc = %{value: value}, incr) do
    %{acc | value: value + incr}
  end

  defp increment_cycle(acc = %{cycle: cycle, value: value, sum: sum}) do
    new_cycle = cycle + 1
    new_sum = calculate_sum(new_cycle, value, sum)
    %{acc | cycle: new_cycle, sum: new_sum}
  end

  @cycles [20, 60, 100, 140, 180, 220]
  defp calculate_sum(cycle, value, sum) when cycle in @cycles do
    IO.inspect("#{cycle} * #{value} = #{cycle * value}")
    sum + cycle * value
  end

  defp calculate_sum(_, _, sum), do: sum

  @spec part_two(String.t()) :: String.t()
  def part_two(file_path) do

    file_path
    |> parse_file()
    |> Enum.reduce(accumulator, &render_pixel/2)
  end

  defp render_pixel() do

  end

  ### Helpers

  defp parse_file(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_line/1)
  end

  defp parse_line("noop"), do: :noop
  defp parse_line("addx " <> value), do: {:addx, String.to_integer(value)}
end
