defmodule Day05 do
  @moduledoc """
  Documentation for `Day05`.
  """

  @doc """
  After the rearrangement procedure completes, what crate ends up on top of each stack?
  """
  @spec part_one(String.t()) :: String.t()
  def part_one(file_path) do
    {stack, procedures} = parse_file(file_path)

    procedures
    |> Enum.reduce(stack, &apply_procedure(&1, &2, :cm9000))
    |> parse_output()
  end

  defp apply_procedure({creates_num, source, destination}, stack, crane) do
    {taken, stack} =
      Map.get_and_update!(stack, source, fn current_value ->
        {taken, remaining} = Enum.split(current_value, creates_num)
      end)

    Map.update!(stack, destination, fn current_value ->
      crane_apply(crane, taken, current_value)
    end)
  end

  def crane_apply(:cm9000, taken, current_value), do: Enum.reverse(taken) ++ current_value
  def crane_apply(:cm9001, taken, current_value), do: taken ++ current_value

  @spec part_two(String.t()) :: String.t()
  def part_two(file_path) do
    {stack, procedures} = parse_file(file_path)

    procedures
    |> Enum.reduce(stack, &apply_procedure(&1, &2, :cm9001))
    |> parse_output()
  end

  ### Helpers

  defp parse_file(file_path) do
    [stack_string, procedures_string] = parse_input(file_path)

    stack = build_stack(stack_string)

    procedures =
      procedures_string
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_procedure/1)

    {stack, procedures}
  end

  defp build_stack(crates) do
    crates
    |> String.split("\n")
    |> Enum.reverse()
    |> tl()
    |> Enum.map(&parse_level(&1, []))
    |> Enum.reduce(%{}, &create_stack/2)
  end

  @digit_regexp ~r{[\D]}
  defp parse_procedure(procedure) do
    procedure
    |> String.split(@digit_regexp, trim: true)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  # No crate
  defp parse_level(<<"   ", tail::binary>>, level), do: parse_level(tail, ["" | level])
  # Space between
  defp parse_level(<<" ", tail::binary>>, level), do: parse_level(tail, level)
  # Crate
  defp parse_level(<<?[, crate, ?], " ", tail::binary>>, level),
    do: parse_level(tail, [List.to_string([crate]) | level])

  # Last crate crate
  defp parse_level(<<?[, crate, ?], tail::binary>>, level),
    do: parse_level(tail, ["" | [List.to_string([crate]) | level]])

  defp parse_level(_, level), do: Enum.reverse(level) |> Enum.with_index(1)

  defp create_stack([], acc), do: acc
  defp create_stack([{"", _} | tail], acc), do: create_stack(tail, acc)

  defp create_stack([{crate, column} | tail], acc) do
    new_acc = Map.update(acc, column, [crate], &[crate | &1])
    create_stack(tail, new_acc)
  end

  defp parse_input(file_path) do
    file_path
    |> File.read!()
    |> String.split("\n\n", trim: true)
  end

  defp parse_output(stack) do
    stack
    |> Enum.map(fn {_, list} -> List.first(list) end)
    |> Enum.join("")
  end
end
