defmodule Day09 do
  @moduledoc """
  Documentation for `Day09`.
  """
  defmodule Accumulator do
    defstruct rope: [], history: MapSet.new([])
  end

  @spec part_one(String.t()) :: integer
  def part_one(file_path) do
    accumulator = %Accumulator{rope: [{0,0}, {0, 0}]}

    file_path
    |> parse_file()
    |> Enum.reduce(accumulator, &move_rope/2)
    |> tail_history()
  end

  defp tail_history(%{history: tail_history}) do
    tail_history
    |> MapSet.to_list()
    |> length()
  end

  @spec part_two(String.t()) :: integer
  def part_two(file_path) do
    file_path
    |> parse_file()
  end

  ### Rope movements
  def move_rope({dir, steps}, accumulator) do
    Enum.reduce(1..steps, accumulator, fn _, %Accumulator{rope: [head_pos, tail_pos], history: history} ->
      {new_head, new_tail} = dir |> move_head(head_pos) |> move_tail(tail_pos)

      %Accumulator{rope: [new_head, new_tail], history: MapSet.put(history, new_tail)}
    end)
  end

  defp move_head("U", {x, y}), do: {x, y + 1}
  defp move_head("D", {x, y}), do: {x, y - 1}
  defp move_head("R", {x, y}), do: {x + 1, y}
  defp move_head("L", {x, y}), do: {x - 1, y}

  defp move_tail(head_pos, {x_tail, y_tail} = tail_pos) do
    cond do
      adjacent?(head_pos, tail_pos) ->
        {head_pos, tail_pos}

      same_y_pos?(head_pos, tail_pos) ->
        possible_tail_pos = [
          {x_tail + 1, y_tail},
          {x_tail - 1, y_tail}
        ]

        {head_pos, valid_tail_pos(head_pos, possible_tail_pos)}

      same_x_pos?(head_pos, tail_pos) ->
        possible_tail_pos = [
          {x_tail, y_tail + 1},
          {x_tail, y_tail - 1}
        ]

        {head_pos, valid_tail_pos(head_pos, possible_tail_pos)}

      true ->
        possible_tail_pos = [
          {x_tail + 1, y_tail + 1},
          {x_tail + 1, y_tail - 1},
          {x_tail - 1, y_tail + 1},
          {x_tail - 1, y_tail - 1}
        ]

        {head_pos, valid_tail_pos(head_pos, possible_tail_pos)}
    end
  end

  defp adjacent?({x, y}, {x, y}), do: true

  defp adjacent?({x_head, y_head}, {x_tail, y_tail}) do
    axis_adjacent?(x_head, x_tail) && axis_adjacent?(y_head, y_tail)
  end

  defp axis_adjacent?(head, tail) do
    Enum.any?((tail - 1)..(tail + 1), &(&1 == head))
  end

  defp same_y_pos?({_, y}, {_, y}), do: true
  defp same_y_pos?(_, _), do: false

  defp same_x_pos?({x, _}, {x, _}), do: true
  defp same_x_pos?(_, _), do: false

  defp valid_tail_pos(head_pos, possible_tail_pos) do
    Enum.find(possible_tail_pos, &adjacent?(head_pos, &1))
  end

  ### Helpers

  defp parse_file(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split/1)
    |> Stream.map(fn [dir, steps] ->
      {dir, String.to_integer(steps)}
    end)
  end
end
