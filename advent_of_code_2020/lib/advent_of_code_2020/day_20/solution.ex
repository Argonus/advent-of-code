defmodule AdventOfCode2020.Day20.Solution do
  @moduledoc """
  The high-speed train leaves the forest and quickly carries you south. You can even see a desert in the distance! Since you have some spare time, you might as well see if there was anything interesting in the image the Mythical Information Bureau satellite captured.

  After decoding the satellite messages, you discover that the data actually contains many small images created by the satellite's camera array. The camera array consists of many cameras; rather than produce a single square image, they produce many smaller square image tiles that need to be reassembled back into a single image.

  Each camera in the camera array returns a single monochrome image tile with a random unique ID number. The tiles (your puzzle input) arrived in a random order.

  Worse yet, the camera array appears to be malfunctioning: each image tile has been rotated and flipped to a random orientation. Your first task is to reassemble the original image by orienting the tiles so they fit together.

  To show how the tiles should be reassembled, each tile's image data includes a border that should line up exactly with its adjacent tiles. All tiles have this border, and the border lines up exactly when the tiles are both oriented correctly. Tiles at the edge of the image also have this border, but the outermost edges won't line up with any other tiles.

  For example, suppose you have the following nine tiles:

  Tile 2311:
  ..##.#..#.
  ##..#.....
  #...##..#.
  ####.#...#
  ##.##.###.
  ##...#.###
  .#.#.#..##
  ..#....#..
  ###...#.#.
  ..###..###

  Tile 1951:
  #.##...##.
  #.####...#
  .....#..##
  #...######
  .##.#....#
  .###.#####
  ###.##.##.
  .###....#.
  ..#.#..#.#
  #...##.#..

  Tile 1171:
  ####...##.
  #..##.#..#
  ##.#..#.#.
  .###.####.
  ..###.####
  .##....##.
  .#...####.
  #.##.####.
  ####..#...
  .....##...

  Tile 1427:
  ###.##.#..
  .#..#.##..
  .#.##.#..#
  #.#.#.##.#
  ....#...##
  ...##..##.
  ...#.#####
  .#.####.#.
  ..#..###.#
  ..##.#..#.

  Tile 1489:
  ##.#.#....
  ..##...#..
  .##..##...
  ..#...#...
  #####...#.
  #..#.#.#.#
  ...#.#.#..
  ##.#...##.
  ..##.##.##
  ###.##.#..

  Tile 2473:
  #....####.
  #..#.##...
  #.##..#...
  ######.#.#
  .#...#.#.#
  .#########
  .###.#..#.
  ########.#
  ##...##.#.
  ..###.#.#.

  Tile 2971:
  ..#.#....#
  #...###...
  #.#.###...
  ##.##..#..
  .#####..##
  .#..####.#
  #..#.#..#.
  ..####.###
  ..#.#.###.
  ...#.#.#.#

  Tile 2729:
  ...#.#.#.#
  ####.#....
  ..#.#.....
  ....#..#.#
  .##..##.#.
  .#.####...
  ####.#.#..
  ##.####...
  ##..#.##..
  #.##...##.

  Tile 3079:
  #.#.#####.
  .#..######
  ..#.......
  ######....
  ####.#..#.
  .#...#.##.
  #.#####.##
  ..#.###...
  ..#.......
  ..#.###...

  By rotating, flipping, and rearranging them, you can find a square arrangement that causes all adjacent borders to line up:

  #...##.#.. ..###..### #.#.#####.
  ..#.#..#.# ###...#.#. .#..######
  .###....#. ..#....#.. ..#.......
  ###.##.##. .#.#.#..## ######....
  .###.##### ##...#.### ####.#..#.
  .##.#....# ##.##.###. .#...#.##.
  #...###### ####.#...# #.#####.##
  .....#..## #...##..#. ..#.###...
  #.####...# ##..#..... ..#.......
  #.##...##. ..##.#..#. ..#.###...

  #.##...##. ..##.#..#. ..#.###...
  ##..#.##.. ..#..###.# ##.##....#
  ##.####... .#.####.#. ..#.###..#
  ####.#.#.. ...#.##### ###.#..###
  .#.####... ...##..##. .######.##
  .##..##.#. ....#...## #.#.#.#...
  ....#..#.# #.#.#.##.# #.###.###.
  ..#.#..... .#.##.#..# #.###.##..
  ####.#.... .#..#.##.. .######...
  ...#.#.#.# ###.##.#.. .##...####

  ...#.#.#.# ###.##.#.. .##...####
  ..#.#.###. ..##.##.## #..#.##..#
  ..####.### ##.#...##. .#.#..#.##
  #..#.#..#. ...#.#.#.. .####.###.
  .#..####.# #..#.#.#.# ####.###..
  .#####..## #####...#. .##....##.
  ##.##..#.. ..#...#... .####...#.
  #.#.###... .##..##... .####.##.#
  #...###... ..##...#.. ...#..####
  ..#.#....# ##.#.#.... ...##.....

  For reference, the IDs of the above tiles are:

  1951    2311    3079
  2729    1427    2473
  2971    1489    1171

  To check that you've assembled the image correctly, multiply the IDs of the four corner tiles together. If you do this with the assembled tiles from the example above, you get 1951 * 3079 * 2971 * 1171 = 20899048083289
  """
  @type file_path :: String.t()

  @edges [:top, :bottom, :left, :right]
  @rotate [false, true]

  @doc """
  Assemble the tiles into an image. What do you get if you multiply together the IDs of the four corner tiles?
  """
  @spec part_one(file_path) :: integer
  def part_one(file_path) do
    tiles =
      file_path
      |> parse_tiles()
      |> Enum.to_list()

    tiles
    |> Enum.filter(&corner_edges?(&1, tiles))
    |> Enum.map(&elem(&1, 0))
    |> Enum.reduce(1, &(&1 * &2))
  end

  defp corner_edges?(target, tiles) do
    length(matching_tiles(target, tiles)) == 2
  end

  defp matching_tiles(target = {idx, _}, tiles) do
    tiles
    |> Enum.reject(&(elem(&1, 0) == idx))
    |> Enum.filter(&matches_tile?(target, &1))
  end

  defp matches_tile?(target, tile) do
    for edge_1 <- @edges, edge_2 <- @edges, rotate <- @rotate do
      {edge_1, edge_2, rotate}
    end
    |> Enum.any?(&matches_edge?(target, tile, &1))
  end

  defp matches_edge?({_, target_map}, {_, tile_map}, {edge1, edge2, rotate}) do
    target_map_edge = fetch_edge(target_map, edge1, false)
    tile_map_edge = fetch_edge(tile_map, edge2, rotate)

    tile_map_edge == target_map_edge
  end

  defp fetch_edge(map, edge, false) do
    Map.fetch!(map, edge)
  end

  defp fetch_edge(map, edge, true) do
    map |> Map.fetch!(edge) |> String.reverse()
  end

  @doc """
  """
  @spec part_two(file_path) :: integer
  def part_two(_file_path) do
    0
  end

  ####################
  # Common functions #
  # ##################

  defp parse_tiles(file_path) do
    file_path
    |> File.stream!()
    |> Stream.chunk_while([], &chunk_fun/2, &after_fun/1)
    |> Stream.map(&parse_tile/1)
  end

  defp chunk_fun("\n", acc), do: {:cont, Enum.reverse(acc), []}
  defp chunk_fun(el, acc), do: {:cont, [String.trim(el) | acc]}

  defp after_fun([]), do: {:cont, []}
  defp after_fun(acc), do: {:cont, Enum.reverse(acc), []}

  defp parse_tile([header | image]) do
    {header_to_idx(header), image_to_edges(image)}
  end

  defp header_to_idx("Tile " <> idx_as_string) do
    idx_as_string
    |> String.replace(":", "")
    |> String.to_integer()
  end

  defp image_to_edges(image = [h | _]) do
    %{
      top: h,
      bottom: List.last(image),
      left: edge(image, :left),
      right: edge(image, :right)
    }
  end

  defp edge(image, :left) do
    image
    |> Enum.map(fn row ->
      row |> String.graphemes() |> List.first()
    end)
    |> Enum.join()
  end

  defp edge(image, :right) do
    image
    |> Enum.map(fn row ->
      row |> String.graphemes() |> List.last()
    end)
    |> Enum.join()
  end
end
