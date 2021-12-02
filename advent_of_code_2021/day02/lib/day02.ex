defmodule Day02 do
  @moduledoc """
  Now, you need to figure out how to pilot this thing.

  It seems like the submarine can take a series of commands like forward 1, down 2, or up 3:

  - forward X increases the horizontal position by X units.
  - down X increases the depth by X units.
  - up X decreases the depth by X units.

  Note that since you're on a submarine, down and up affect your depth, and so they have the opposite result of what you might expect.
  The submarine seems to already have a planned course (your puzzle input). You should probably figure out where it's going. For example:

  forward 5
  down 5
  forward 8
  up 3
  down 8
  forward 2

  Your horizontal position and depth both start at 0. The steps above would then modify them as follows:

  forward 5 adds 5 to your horizontal position, a total of 5.
  down 5 adds 5 to your depth, resulting in a value of 5.
  forward 8 adds 8 to your horizontal position, a total of 13.
  up 3 decreases your depth by 3, resulting in a value of 2.
  down 8 adds 8 to your depth, resulting in a value of 10.
  forward 2 adds 2 to your horizontal position, a total of 15.
  After following these instructions, you would have a horizontal position of 15 and a depth of 10. (Multiplying these together produces 150.)
  """

  @doc """
  Calculate the horizontal position and depth you would have after following the planned course.
  What do you get if you multiply your final horizontal position by your final depth?
  """
  @spec part_one(String.t()) :: integer
  def part_one(file_path) do
    state = %{horizontal: 0, depth: 0}

    file_path
    |> File.stream!()
    |> Stream.map(&parse_line/1)
    |> Enum.reduce(state, &move_submarine_one/2)
    |> calculate_result()
  end

  defp parse_line(line) do
    [dir, pos] = line |> String.trim() |> String.split(" ")
    {dir, String.to_integer(pos)}
  end

  defp move_submarine_one({"forward", value}, acc = %{horizontal: h}), do: %{acc | horizontal: h + value}
  defp move_submarine_one({"up", value}, acc = %{depth: d}), do: %{acc | depth: d - value}
  defp move_submarine_one({"down", value}, acc = %{depth: d}), do: %{acc | depth: d + value}

  defp calculate_result(%{horizontal: h, depth: d}), do: h * d

  @doc """
  Based on your calculations, the planned course doesn't seem to make any sense.
  You find the submarine manual and discover that the process is actually slightly more complicated.

  In addition to horizontal position and depth, you'll also need to track a third value, aim, which also starts at 0.
  The commands also mean something entirely different than you first thought:

  - down X increases your aim by X units.
  - up X decreases your aim by X units.
  - forward X does two things:
    - It increases your horizontal position by X units.
    - It increases your depth by your aim multiplied by X.

  Again note that since you're on a submarine, down and up do the opposite of what you might expect: "down" means aiming in the positive direction.

  Using this new interpretation of the commands, calculate the horizontal position and depth you would have after following the planned course.
  What do you get if you multiply your final horizontal position by your final depth?
  """
  @spec part_two(String.t()) :: integer
  def part_two(file_path) do
    state = %{horizontal: 0, depth: 0, aim: 0}

    file_path
    |> File.stream!()
    |> Stream.map(&parse_line/1)
    |> Enum.reduce(state, &move_submarine_two/2)
    |> calculate_result()
  end

  defp move_submarine_two({"down", value}, acc = %{aim: a}), do: %{acc | aim: a + value}
  defp move_submarine_two({"up", value}, acc = %{aim: a}), do: %{acc | aim: a - value}

  defp move_submarine_two({"forward", value}, acc = %{horizontal: h, depth: d, aim: a}) do
    new_horizontal = h + value
    new_depth = d + a * value

    %{acc | horizontal: new_horizontal, depth: new_depth}
  end
end
