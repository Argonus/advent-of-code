defmodule Day08 do
  @moduledoc """
  Documentation for `Day08`.
  """

  @spec part_one(String.t()) :: integer
  def part_one(file_path) do
    forest = file_path |> build_forest()
    boundaries = find_boundaries(forest)

    Enum.reduce(forest, 0, &count_visible(&1, forest, boundaries, &2))
  end

  defp count_visible(tree, forest, boundaries, acc) do
    cond do
      on_the_edge?(tree, boundaries) -> acc + 1
      tree_visible?(tree, forest, boundaries) -> acc + 1
      true -> acc
    end
  end

  defp on_the_edge?({{x, _}, _}, %{min_x: min_x}) when x == min_x, do: true
  defp on_the_edge?({{x, _}, _}, %{max_x: max_x}) when x == max_x, do: true
  defp on_the_edge?({{_, y}, _}, %{min_y: min_y}) when y == min_y, do: true
  defp on_the_edge?({{_, y}, _}, %{max_y: max_y}) when y == max_y, do: true
  defp on_the_edge?(_, _), do: false

  defp tree_visible?({{x, y}, height}, forest, boundaries) do
    %{min_x: min_x, max_x: max_x, min_y: min_y, max_y: max_y} = boundaries

    cond do
      Enum.all?((x - 1)..min_x, &(get_height(&1, y, forest) < height)) -> true
      Enum.all?((x + 1)..max_x, &(get_height(&1, y, forest) < height)) -> true
      Enum.all?((y - 1)..min_y, &(get_height(x, &1, forest) < height)) -> true
      Enum.all?((y + 1)..max_y, &(get_height(x, &1, forest) < height)) -> true
      true -> false
    end
  end

  defp get_height(x, y, forest), do: Map.fetch!(forest, {x, y})

  @spec part_two(String.t()) :: integer
  def part_two(file_path) do
    forest = file_path |> build_forest()
    boundaries = find_boundaries(forest)

    forest
    |> Enum.reject(&on_the_edge?(&1, boundaries))
    |> Enum.map(&count_score(&1, forest, boundaries))
    |> Enum.max()
  end

  defp count_score({{x, y}, tree_height}, forest, boundaries) do
    %{min_x: min_x, max_x: max_x, min_y: min_y, max_y: max_y} = boundaries

    score_down = Enum.reduce_while((x - 1)..min_x, 0, &score_reducer(&1, y, tree_height, forest, boundaries, &2))
    score_up = Enum.reduce_while((x + 1)..max_x, 0, &score_reducer(&1, y, tree_height, forest, boundaries, &2))
    score_right = Enum.reduce_while((y - 1)..min_y, 0, &score_reducer(x, &1, tree_height, forest, boundaries, &2))
    score_left = Enum.reduce_while((y + 1)..max_y, 0, &score_reducer(x, &1, tree_height, forest, boundaries, &2))

    if x == 2 && y == 3 do
      Enum.map((x - 1)..min_x, &get_height(&1, y, forest)) |> IO.inspect()
    end

    score_up * score_down * score_right * score_left
  end

  defp score_reducer(x, y, tree_height, forest, boundaries, acc) do
    if get_height(x, y, forest) < tree_height do
      {:cont, acc + 1}
    else
      {:halt, acc + 1}
    end
  end

  ### Helpers

  defp build_forest(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.with_index()
    |> Enum.reduce(%{}, fn {row_value, row_num}, forest ->
      row_value
      |> String.codepoints()
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.reduce(forest, fn {tree_height, col_num}, acc ->
        Map.put(acc, {col_num, row_num}, tree_height)
      end)
    end)
  end

  defp find_boundaries(forest) do
    max_x = forest |> Map.keys() |> Enum.map(&elem(&1, 0)) |> Enum.max()
    max_y = forest |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.max()
    %{min_x: 0, min_y: 0, max_x: max_x, max_y: max_y}
  end
end
