defmodule AdventOfCode2020.Day1.PartTwo do
  @moduledoc """
  --- Part Two ---
  The Elves in accounting are thankful for your help; one of them even offers you a starfish coin they had left over from a past vacation. They offer you a second one if you can find three numbers in your expense report that meet the same criteria.

  Using the above example again, the three entries that sum to 2020 are 979, 366, and 675. Multiplying them together produces the answer, 241861950.
  """
  import AdventOfCode2020.Day1.FileHelpers
  import AdventOfCode2020.Day1.ListHelpers

  @year 2020
  @combine_number 2

  @type file_path :: String.t()
  @type result :: {integer, {integer, integer, integer}}

  @spec find(file_path) :: {:ok, [result]} | {:error, :not_found}
  def find(file_path) do
    list = parse_file(file_path)

    list
    |> combine(@combine_number)
    |> find_trio(list, [])
    |> Enum.uniq()
    |> parse_result()
  end

  defp find_trio([], _list, acc), do: acc

  defp find_trio([head | tail], list, acc) do
    [el1, el2] = head
    maybe_el3 = @year - el1 - el2

    if Enum.member?(list, maybe_el3) && maybe_el3 != el1 && maybe_el3 != el2 do
      result = Enum.sort([el1, el2, maybe_el3])
      find_trio(tail, list, [result | acc])
    else
      find_trio(tail, list, acc)
    end
  end

  defp parse_result([]), do: {:error, :not_found}

  defp parse_result(results) do
    results =
      Enum.map(results, fn [el1, el2, el3] ->
        {el1 * el2 * el3, {el1, el2, el3}}
      end)

    {:ok, results}
  end
end
