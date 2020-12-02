defmodule AdventOfCode2020.Day1.ListHelpers do
  @moduledoc false

  @spec combine(list, integer) :: [list]
  def combine(input_list, combinations) do
    list_length = Enum.count(input_list)
    do_combine(input_list, list_length, combinations, [], [])
  end

  defp do_combine(_list, _list_length, 0, _pick_acc, _acc), do: [[]]
  defp do_combine(list, _list_length, 1, _pick_acc, _acc), do: list |> Enum.map(&[&1])

  defp do_combine(list, list_length, combinations, pick_acc, acc) do
    list
    |> Stream.unfold(fn [head | tail] -> {{head, tail}, tail} end)
    |> Enum.take(list_length)
    |> Enum.reduce(acc, fn {el, sublist}, acc ->
      sublist_length = Enum.count(sublist)
      pick_acc_length = Enum.count(pick_acc)

      if combinations > pick_acc_length + 1 + sublist_length do
        acc
      else
        new_pick_acc = [el | pick_acc]
        new_pick_acc_length = pick_acc_length + 1

        case new_pick_acc_length do
          ^combinations -> [new_pick_acc | acc]
          _ -> do_combine(sublist, sublist_length, combinations, new_pick_acc, acc)
        end
      end
    end)
  end
end
