defmodule Day01 do
  @moduledoc """
  As the submarine drops below the surface of the ocean, it automatically performs a sonar sweep of the nearby sea floor.
  On a small screen, the sonar sweep report (your puzzle input) appears: each line is a measurement of the sea
  floor depth as the sweep looks further and further away from the submarine.

  For example, suppose you had the following report:

  199
  200
  208
  210
  200
  207
  240
  269
  260
  263

  This report indicates that, scanning outward from the submarine, the sonar sweep found depths of 199, 200, 208, 210, and so on.
  """

  @doc """
  The first order of business is to figure out how quickly the depth increases,
  just so you know what you're dealing with - you never know if the keys will get carried
  into deeper water by an ocean current or a fish or something.

  To do this, count the number of times a depth measurement increases from the previous measurement.
  (There is no measurement before the first measurement.) In the example above, the changes are as follows:
  """
  @spec part_one(String.t()) :: integer
  def part_one(file_path) do
    acc = %{prev_value: nil, count: 0}

    file_path
    |> File.stream!()
    |> Stream.map(&parse_line/1)
    |> Enum.reduce(acc, &add_counter/2)
    |> Map.fetch!(:count)
  end

  defp parse_line(line) do
    line |> String.trim() |> String.to_integer()
  end

  def add_counter(value, acc = %{prev_value: nil}), do: %{acc | prev_value: value}

  def add_counter(value, %{prev_value: prev_value, count: count}) when prev_value < value do
    %{prev_value: value, count: count + 1}
  end

  def add_counter(value, acc), do: %{acc | prev_value: value}

  @doc """
  Considering every single measurement isn't as useful as you expected: there's just too much noise in the data.
  Instead, consider sums of a three-measurement sliding window. Again considering the above example:

  Start by comparing the first and second three-measurement windows.
  The measurements in the first window are marked A (199, 200, 208); their sum is 199 + 200 + 208 = 607.
  The second window is marked B (200, 208, 210); its sum is 618.
  The sum of measurements in the second window is larger than the sum of the first, so this first comparison increased.

  Your goal now is to count the number of times the sum of measurements in this sliding window increases from the previous sum.
  So, compare A with B, then compare B with C, then C with D, and so on.
  Stop when there aren't enough measurements left to create a new three-measurement sum.
  """
  @spec part_two(String.t()) :: integer
  def part_two(file_path) do
    acc = %{prev_value: nil, count: 0}

    file_path
    |> File.stream!()
    |> Stream.map(&parse_line/1)
    |> Stream.chunk_every(3, 1, :discard)
    |> Stream.map(&Enum.sum(&1))
    |> Enum.reduce(acc, &add_counter/2)
    |> Map.fetch!(:count)
  end
end
