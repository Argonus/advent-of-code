defmodule Day05 do
  @moduledoc """
  You come across a field of hydrothermal vents on the ocean floor!
  These vents constantly produce large, opaque clouds, so it would be best to avoid them if possible.

  They tend to form in lines; the submarine helpfully produces a list of nearby lines of vents
  (your puzzle input) for you to review. For example:

  Each line of vents is given as a line segment in the format x1,y1 -> x2,y2 where x1,y1 are the
  coordinates of one end the line segment and x2,y2 are the coordinates of the other end.
  These line segments include the points at both ends. In other words:

  An entry like 1,1 -> 1,3 covers points 1,1, 1,2, and 1,3.
  An entry like 9,7 -> 7,7 covers points 9,7, 8,7, and 7,7.

  For now, only consider horizontal and vertical lines: lines where either x1 = x2 or y1 = y2

  So, the horizontal and vertical lines from the above list would produce the following diagram:

  .......1..
  ..1....1..
  ..1....1..
  .......1..
  .112111211
  ..........
  ..........
  ..........
  ..........
  222111....

  In this diagram, the top left corner is 0,0 and the bottom right corner is 9,9.
  Each position is shown as the number of lines which cover that point or . if no line covers that point.
  The top-left pair of 1s, for example, comes from 2,2 -> 2,1; the very bottom row is formed
  by the overlapping lines 0,9 -> 5,9 and 0,9 -> 2,9.
  """

  @doc """
  To avoid the most dangerous areas, you need to determine the number of points where at
  least two lines overlap.
  In the above example, this is anywhere in the diagram with a 2 or larger - a total of 5 points.
  Consider only horizontal and vertical lines. At how many points do at least two lines overlap?
  """
  @spec part_one(String.t()) :: integer
  def part_one(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&parse_line/1)
    |> Stream.map(&build_coords/1)
    |> Stream.filter(&is_vertical?/1)
    |> Enum.reduce(%{}, &mark_vertical/2)
    |> Enum.count(&is_dangerous?/1)
  end

  defp parse_line(line) do
    line |> String.trim() |> String.split(" -> ", trim: true)
  end

  defp build_coords([pos1, pos2]) do
    {x1, y1} = to_cords(pos1)
    {x2, y2} = to_cords(pos2)

    %{x1y1: {x1, y1}, x2y2: {x2, y2}}
  end

  defp to_cords(line) do
    [x, y] = line |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)
    {x, y}
  end

  defp is_vertical?(%{x1y1: {x, _}, x2y2: {x, _}}), do: true
  defp is_vertical?(%{x1y1: {_, y}, x2y2: {_, y}}), do: true
  defp is_vertical?(%{x1y1: {_, _}, x2y2: {_, _}}), do: false

  defp mark_vertical(%{x1y1: {x, y1}, x2y2: {x, y2}}, grid) do
    [y_min, y_max] = Enum.sort([y1, y2])
    Enum.reduce(y_min..y_max, grid, &update_map({x, &1}, &2))
  end

  defp mark_vertical(%{x1y1: {x1, y}, x2y2: {x2, y}}, grid) do
    [x_min, x_max] = Enum.sort([x1, x2])
    Enum.reduce(x_min..x_max, grid, &update_map({&1, y}, &2))
  end

  defp update_map({x, y}, grid) do
    Map.update(grid, {x, y}, 1, fn val -> val + 1 end)
  end

  @threshold 2
  defp is_dangerous?({_, val}) when val >= @threshold, do: true
  defp is_dangerous?({_, _}), do: false

  @doc """
  Unfortunately, considering only horizontal and vertical lines doesn't give you the full picture;
  you need to also consider diagonal lines.

  Because of the limits of the hydrothermal vent mapping system, the lines in your list will only ever be horizontal,
  vertical, or a diagonal line at exactly 45 degrees. In other words:

  - An entry like 1,1 -> 3,3 covers points 1,1, 2,2, and 3,3.
  - An entry like 9,7 -> 7,9 covers points 9,7, 8,8, and 7,9.

  You still need to determine the number of points where at least two lines overlap.
  In the above example, this is still anywhere in the diagram with a 2 or larger - now a total of 12 points.

  Consider all of the lines. At how many points do at least two lines overlap?
  """

  @spec part_two(String.t()) :: integer
  def part_two(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&parse_line/1)
    |> Stream.map(&build_coords/1)
    |> Enum.reduce(%{}, &mark_vertical_or_diagonal/2)
    |> Enum.count(&is_dangerous?/1)
  end

  defp mark_vertical_or_diagonal(pos, grid) do
    cond do
      is_vertical?(pos) ->
        mark_vertical(pos, grid)

      is_diagonal?(pos) ->
        mark_diagonal(pos, grid)

      true ->
        grid
    end
  end

  defp is_diagonal?(%{x1y1: {x1, y1}, x2y2: {x2, y2}}) do
    x_diff = abs(x1 - x2)
    y_diff = abs(y1 - y2)

    x_diff == y_diff
  end

  defp mark_diagonal(%{x1y1: {x1, y1}, x2y2: {x2, y2}}, acc) do
    diagonal_cords = Enum.zip(x1..x2, y1..y2)

    Enum.reduce(diagonal_cords, acc, &update_map(&1, &2))
  end
end
