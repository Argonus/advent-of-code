defmodule AdventOfCode2020.Day12.Solution do
  @moduledoc """
  Your ferry made decent progress toward the island, but the storm came in faster than anyone expected. The ferry needs to take evasive actions!

  Unfortunately, the ship's navigation computer seems to be malfunctioning; rather than giving a route directly to safety, it produced extremely circuitous instructions. When the captain uses the PA system to ask if anyone can help, you quickly volunteer.

  The navigation instructions (your puzzle input) consists of a sequence of single-character actions paired with integer input values. After staring at them for a few minutes, you work out what they probably mean:

  - Action N means to move north by the given value.
  - Action S means to move south by the given value.
  - Action E means to move east by the given value.
  - Action W means to move west by the given value.
  - Action L means to turn left the given number of degrees.
  - Action R means to turn right the given number of degrees.
  - Action F means to move forward by the given value in the direction the ship is currently facing.

  The ship starts by facing east. Only the L and R actions change the direction the ship is facing. (That is, if the ship is facing east and the next instruction is N10, the ship would move north 10 units, but would still move east if the following action were F.)

  For example:

  F10
  N3
  F7
  R90
  F11

  These instructions would be handled as follows:

  - F10 would move the ship 10 units east (because the ship starts by facing east) to east 10, north 0.
  - N3 would move the ship 3 units north to east 10, north 3.
  - F7 would move the ship another 7 units east (because the ship is still facing east) to east 17, north 3.
  - R90 would cause the ship to turn right by 90 degrees and face south; it remains at east 17, north 3.
  - F11 would move the ship 11 units south to east 17, south 8.

  At the end of these instructions, the ship's Manhattan distance (sum of the absolute values of its east/west position and its north/south position) from its starting position is 17 + 8 = 25.

  Figure out where the navigation instructions lead. What is the Manhattan distance between that location and the ship's starting position?
  """

  #   N
  #   |
  # W-- -- E
  #   |
  #   S

  @type file_path :: String.t()
  @line_regexp ~r{(\w)(\d+)}
  @turn_ship_action ["L", "R"]

  @spec part_one(file_path) :: integer
  def part_one(file_path) do
    state = %{pos: %{x: 0, y: 0}, dir: %{x: 1, y: 0}}

    file_path
    |> File.stream!()
    |> Stream.map(&build_actions/1)
    |> Enum.reduce(state, &navigate/2)
    |> calculate_result()
  end

  defp build_actions(line) do
    [dir, value] = line |> String.trim() |> split_line()
    {dir, String.to_integer(value)}
  end

  defp split_line(line), do: Regex.run(@line_regexp, line, capture: :all_but_first)

  defp navigate(action, state) do
    case action do
      {change, _} when change in @turn_ship_action -> turn_ship(action, state)
      _ -> move_ship(action, state)
    end
  end

  # Movements does not changes dir
  defp move_ship({"N", value}, state = %{pos: pos = %{y: y}}),
    do: %{state | pos: %{pos | y: y - value}}

  defp move_ship({"S", value}, state = %{pos: pos = %{y: y}}),
    do: %{state | pos: %{pos | y: y + value}}

  defp move_ship({"E", value}, state = %{pos: pos = %{x: x}}),
    do: %{state | pos: %{pos | x: x + value}}

  defp move_ship({"W", value}, state = %{pos: pos = %{x: x}}),
    do: %{state | pos: %{pos | x: x - value}}

  defp move_ship({"F", value}, state = %{pos: %{x: x, y: y}, dir: %{x: x_dir, y: y_dir}}) do
    new_x = x + x_dir * value
    new_y = y + y_dir * value

    %{state | pos: %{x: new_x, y: new_y}}
  end

  # Turn ship
  defp turn_ship(action, state = %{dir: dir}) do
    new_dir = rotate(action, dir)
    %{state | dir: new_dir}
  end

  def rotate({"R", degree}, %{x: x, y: y}) do
    case degree do
      90 -> %{x: -y, y: x}
      180 -> %{x: -x, y: -y}
      270 -> %{x: y, y: -x}
    end
  end

  def rotate({"L", degree}, %{x: x, y: y}) do
    case degree do
      90 -> %{x: y, y: -x}
      180 -> %{x: -x, y: -y}
      270 -> %{x: -y, y: x}
    end
  end

  defp calculate_result(%{pos: %{x: x, y: y}}), do: abs(x) + abs(y)

  @doc """
  Before you can give the destination to the captain, you realize that the actual action meanings were printed on the back of the instructions the whole time.

  Almost all of the actions indicate how to move a waypoint which is relative to the ship's position:

  - Action N means to move the waypoint north by the given value.
  - Action S means to move the waypoint south by the given value.
  - Action E means to move the waypoint east by the given value.
  - Action W means to move the waypoint west by the given value.
  - Action L means to rotate the waypoint around the ship left (counter-clockwise) the given number of degrees.
  - Action R means to rotate the waypoint around the ship right (clockwise) the given number of degrees.
  - Action F means to move forward to the waypoint a number of times equal to the given value.

  The waypoint starts 10 units east and 1 unit north relative to the ship. The waypoint is relative to the ship; that is, if the ship moves, the waypoint moves with it.

  For example, using the same instructions as above:

  - F10 moves the ship to the waypoint 10 times (a total of 100 units east and 10 units north), leaving the ship at east 100, north 10. The waypoint stays 10 units east and 1 unit north of the ship.
  - N3 moves the waypoint 3 units north to 10 units east and 4 units north of the ship. The ship remains at east 100, north 10.
  - F7 movesthe ship to the waypoint 7 times (a total of 70 units east and 28 units north), leaving the ship at east 170, north 38. The waypoint stays 10 units east and 4 units north of the ship.
  - R90 rotates the waypoint around the ship clockwise 90 degrees, moving it to 4 units east and 10 units south of the ship. The ship remains at east 170, north 38.
  - F11 moves the ship to the waypoint 11 times (a total of 44 units east and 110 units south), leaving the ship at east 214, south 72. The waypoint stays 4 units east and 10 units south of the ship.

  After these operations, the ship's Manhattan distance from its starting position is 214 + 72 = 286.

  Figure out where the navigation instructions actually lead. What is the Manhattan distance between that location and the ship's starting position?
  """
  @spec part_two(file_path) :: integer
  def part_two(file_path) do
    state = %{
      pos: %{x: 0, y: 0},
      dir: %{x: 10, y: -1}
    }

    file_path
    |> File.stream!()
    |> Stream.map(&build_actions/1)
    |> Enum.reduce(state, &navigate_by_waypoint/2)
    |> calculate_result()
  end

  defp navigate_by_waypoint(action, state) do
    case action do
      {"F", _} -> move_ship(action, state)
      {change, _} when change in @turn_ship_action -> turn_ship(action, state)
      _ -> move_waypoint(action, state)
    end
  end

  defp move_waypoint({"N", value}, state = %{dir: dir = %{y: y}}),
    do: %{state | dir: %{dir | y: y - value}}

  defp move_waypoint({"S", value}, state = %{dir: dir = %{y: y}}),
    do: %{state | dir: %{dir | y: y + value}}

  defp move_waypoint({"E", value}, state = %{dir: dir = %{x: x}}),
    do: %{state | dir: %{dir | x: x + value}}

  defp move_waypoint({"W", value}, state = %{dir: dir = %{x: x}}),
    do: %{state | dir: %{dir | x: x - value}}
end
