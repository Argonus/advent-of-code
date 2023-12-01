defmodule Day06 do
  @moduledoc """
  Documentation for `Day06`.
  """

  @spec part_one(String.t()) :: integer
  def part_one(file_path) do
    file_path
    |> parse_file()
    |> do_check([], 0, 4)
  end

  defp do_check(list, [], 0, size) do
    {h, t} = Enum.split(list, size - 1)
    do_check(t, h, size - 1, size)
  end

  defp do_check([h | t], acc, n, size) do
    maybe_token = acc ++ [h]
    position = n + 1

    if Enum.uniq(maybe_token) == maybe_token do
      position
    else
      [_ | new_acc] = maybe_token
      do_check(t, new_acc, position, size)
    end
  end

  @spec part_two(String.t()) :: integer
  def part_two(file_path) do
    file_path
    |> parse_file()
    |> do_check([], 0, 14)
  end

  ### Helpers
  def parse_file(file_path) do
    file_path
    |> File.read!()
    |> String.graphemes()
  end
end
