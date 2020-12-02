defmodule AdventOfCode2020.Day1.FileHelpers do
  @moduledoc false

  @type file_path :: String.t()

  @spec parse_file(file_path) :: [integer]
  def parse_file(file_path) do
    file_path
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&to_integer/1)
    |> Enum.reject(&is_nil(&1))
  end

  defp to_integer(string) do
    case Integer.parse(string) do
      :error -> nil
      {int, _} -> int
    end
  end
end
