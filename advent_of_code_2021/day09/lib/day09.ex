defmodule Day09 do
  @moduledoc """
  These caves seem to be lava tubes. Parts are even still volcanically active;
  small hydrothermal vents release smoke into the caves that slowly settles like rain.

  If you can model how the smoke flows through the caves, you might be able to avoid it and be that much safer.
  The submarine generates a heightmap of the floor of the nearby caves for you (your puzzle input).

  Smoke flows to the lowest point of the area it's in. For example, consider the following heightmap:

  2199943210
  3987894921
  9856789892
  8767896789
  9899965678

  Each number corresponds to the height of a particular location, where 9 is the highest and 0 is the lowest a location can be.
  """

  @doc """
  Your first goal is to find the low points - the locations that are lower than any of its adjacent locations.
  Most locations have four adjacent locations (up, down, left, and right);
  locations on the edge or corner of the map have three or two adjacent locations, respectively.
  (Diagonal locations do not count as adjacent.)

  In the above example, there are four low points, all highlighted:
  two are in the first row (a 1 and a 0), one is in the third row (a 5), and one is in the bottom row (also a 5).
  All other locations on the heightmap have some lower adjacent location, and so are not low points.

  The risk level of a low point is 1 plus its height. In the above example, the risk levels of the low points are 2, 1, 6, and 6.
  The sum of the risk levels of all low points in the heightmap is therefore 15.

  Find all of the low points on your heightmap. What is the sum of the risk levels of all low points on your heightmap?
  """
  @spec part_one(String.t()) :: integer
  def part_one(file_path) do
    file_path
    |> parse_input()
    |> build_depth_map()
    |> find_lowest_points()
    |> calculate_risk()
  end

  defp find_lowest_points(depth_map) do
    points =
      Enum.reduce(depth_map, [], fn {cords, depth}, acc ->
        neighbour_depths = get_neighbour_depths(cords, depth_map)

        if Enum.all?(neighbour_depths, &(&1 > depth)) do
          [cords | acc]
        else
          acc
        end
      end)

    {points, depth_map}
  end

  defp get_neighbour_depths({x, y}, depth_map) do
    x
    |> neighbour_cords(y)
    |> Enum.map(&Map.get(depth_map, &1))
    |> Enum.reject(&is_nil(&1))
  end

  defp neighbour_cords(x, y), do: [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]

  defp calculate_risk({points, depth_map}) do
    Enum.reduce(points, 0, fn point, acc ->
      depth = depth_map |> Map.fetch!(point) |> String.to_integer()
      acc + (depth + 1)
    end)
  end

  defp parse_input(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.graphemes/1)
  end

  defp build_depth_map(lines_stream) do
    lines_stream
    |> Stream.with_index()
    |> Enum.reduce(%{}, fn {row, y_idx}, acc ->
      row
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {depth, x_idx}, acc2 ->
        Map.put(acc2, {x_idx, y_idx}, depth)
      end)
    end)
  end

  @doc """
  Next, you need to find the largest basins so you know what areas are most important to avoid.

  A basin is all locations that eventually flow downward to a single low point.
  Therefore, every low point has a basin, although some basins are very small.
  Locations of height 9 do not count as being in any basin, and all other locations will always be part of exactly one basin.

  The size of a basin is the number of locations within the basin, including the low point. The example above has four basins.

  Find the three largest basins and multiply their sizes together. In the above example, this is 9 * 14 * 9 = 1134

  What do you get if you multiply together the sizes of the three largest basins?
  """
  @spec part_two(String.t()) :: integer
  def part_two(file_path) do
    file_path
    |> parse_input()
    |> build_depth_map()
    |> find_lowest_points()
    |> find_basins()
    |> Enum.map(&Enum.count/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.reduce(1, &(&1 * &2))
  end

  defp find_basins({low_points, depth_map}) do
    Enum.map(low_points, &find_basin(&1, depth_map))
  end

  defp find_basin(point, depth_map) do
    do_find_basin([point], depth_map, [])
  end

  defp do_find_basin([], _, basin), do: Enum.uniq(basin)

  defp do_find_basin([{x, y} = cords | tail], depth_map, basin) do
    neighbours = neighbour_cords(x, y)
    valid_neighbours = Enum.filter(neighbours, &is_valid_basin_point?(&1, cords, depth_map))
    new_points = tail ++ valid_neighbours
    new_basin = [cords | basin]

    do_find_basin(new_points, depth_map, new_basin)
  end

  defp is_valid_basin_point?(n_cords, cords, depth_map) do
    n_depth = Map.get(depth_map, n_cords) |> to_integer()
    depth = Map.get(depth_map, cords) |> to_integer()

    if !is_nil(n_depth) && n_depth != 9 && n_depth > depth do
      true
    else
      false
    end
  end

  defp to_integer(nil), do: nil
  defp to_integer(var), do: String.to_integer(var)
end
