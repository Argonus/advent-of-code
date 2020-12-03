defmodule AdventOfCode2020.Day3.Solution do
  @moduledoc """
  With the toboggan login problems resolved, you set off toward the airport. While travel by toboggan might be easy, it's certainly not safe: there's very minimal steering and the area is covered in trees. You'll need to see which angles will take you near the fewest trees.

  Due to the local geology, trees in this area only grow on exact integer coordinates in a grid. You make a map (your puzzle input) of the open squares (.) and trees (#) you can see. For example:

  The toboggan can only follow a few specific slopes (you opted for a cheaper model that prefers rational numbers); start by counting all the trees you would encounter for the slope right 3, down 1:

  From your starting position at the top-left, check the position that is right 3 and down 1. Then, check the position that is right 3 and down 1 from there, and so on until you go past the bottom of the map.

  The locations you'd check in the above example are marked here with O where there was an open square and X where there was a tree:
  """

  @type file_path :: String.t()

  @doc """
  Starting at the top-left corner of your map and following a slope of right 3 and down 1, how many trees would you encounter?
  """
  @spec part_one(file_path) :: integer
  def part_one(file_path, x_add \\ 3, y_add \\ 1) do
    acc = %{x: 0, y: 0, trees: 0}
    movement = %{x: x_add, y: y_add}

    file_path
    |> File.stream!()
    |> Stream.map(&build_row/1)
    |> Enum.to_list()
    |> check_tree_list(movement, acc)
    |> Map.fetch!(:trees)
  end

  defp build_row(line) do
    line
    |> String.trim()
    |> String.split("", trim: true)
  end

  defp check_tree_list(list, _, acc = %{y: y}) when length(list) - 1 <= y, do: acc

  defp check_tree_list(list = [head | _], movement = %{x: x_add, y: y_add}, %{
         x: x,
         y: y,
         trees: trees
       }) do
    new_x = (x + x_add) |> rem(length(head))
    new_y = y + y_add

    new_acc =
      if is_tree?(Enum.at(list, new_y), new_x) do
        %{x: new_x, y: new_y, trees: trees + 1}
      else
        %{x: new_x, y: new_y, trees: trees}
      end

    check_tree_list(list, movement, new_acc)
  end

  defp is_tree?(line, index) do
    case Enum.at(line, index) do
      "#" -> true
      _ -> false
    end
  end

  @movements [
    %{x: 1, y: 1},
    %{x: 3, y: 1},
    %{x: 5, y: 1},
    %{x: 7, y: 1},
    %{x: 1, y: 2}
  ]

  @doc """
  What do you get if you multiply together the number of trees encountered on each of the listed slopes?
  """
  @spec part_two(file_path) :: integer
  def part_two(file_path) do
    Enum.reduce(@movements, 1, fn %{x: x, y: y}, acc ->
      trees = part_one(file_path, x, y)
      acc * trees
    end)
  end
end
