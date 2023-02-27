defmodule Day11 do
  @moduledoc """
  Documentation for `Day11`.
  """

  defmodule Monkey do
    defstruct [:id, :items_worry, :operation, :test_factor, :true_destination, :false_destination, inspects: 0]

    def new(lines) do
      Enum.reduce(lines, %__MODULE__{}, &parse_line/2)
    end

    defp parse_line("Monkey " <> id, acc), do: %{acc | id: parse_id(id)}
    defp parse_line("Starting items: " <> iw, acc), do: %{acc | items_worry: parse_items(iw)}
    defp parse_line("Operation: " <> opp, acc), do: %{acc | operation: operation_fn(opp)}
    defp parse_line("Test: divisible by " <> tf, acc), do: %{acc | test_factor: String.to_integer(tf)}
    defp parse_line("If true: throw to monkey " <> id, acc), do: %{acc | true_destination: String.to_integer(id)}
    defp parse_line("If false: throw to monkey " <> id, acc), do: %{acc | false_destination: String.to_integer(id)}
    defp parse_line(_, acc), do: acc

    defp parse_id(id_line) do
      id_line |> String.replace(":", "") |> String.to_integer()
    end

    defp parse_items(items_line) do
      items_line
      |> String.split(", ")
      |> Enum.map(&String.to_integer/1)
    end

    @operation_regexp ~r/(\w+)\s([+*])\s(\w+)/
    defp operation_fn("new = " <> operation) do
      [_, val1, action, val2] = Regex.run(@operation_regexp, operation)

      case action do
        "*" ->
          fn old ->
            multiply(old, parse_value(val1), parse_value(val2))
          end

        "+" ->
          fn old ->
            add(old, parse_value(val1), parse_value(val2))
          end
      end
    end

    defp parse_value("old"), do: :old
    defp parse_value(integer), do: String.to_integer(integer)

    defp multiply(old, val1, val2), do: value(old, val1) * value(old, val2)
    defp add(old, val1, val2), do: value(old, val1) + value(old, val2)

    defp value(old, :old), do: old
    defp value(_, value), do: value
  end

  @rounds_one 20

  @spec part_one(String.t()) :: integer
  def part_one(file_path) do
    monkeys = file_path |> parse_file()

    1..@rounds_one
    |> Enum.reduce(monkeys, &play_round(&1, &2, :by_three))
    |> fetch_result()
  end

  defp compute_factor(monkeys) do
    monkeys
    |> Map.values()
    |> get_in([Access.all(), Access.key!(:test_factor)])
    |> Enum.reduce(&(&1 * &2))
  end

  defp play_round(_round_n, monkeys, factor) do
    0..(map_size(monkeys) - 1)
    |> Enum.reduce(monkeys, fn monkey_id, monkeys ->
      # Take items & update accumulator
      current_monkey = Map.fetch!(monkeys, monkey_id)
      current_monkey_items = current_monkey.items_worry

      current_monkey_items
      |> Enum.map(&play_item(&1, current_monkey, factor))
      |> build_new_items()
      |> Enum.reduce(monkeys, fn {id, new_items}, acc ->
        update_in(acc, [Access.key!(id), Access.key!(:items_worry)], &(&1 ++ new_items))
      end)
      |> put_in([Access.key!(monkey_id), Access.key!(:items_worry)], [])
      |> update_in([Access.key!(monkey_id), Access.key!(:inspects)], &(&1 + length(current_monkey_items)))
    end)
  end

  defp play_item(item_worry_level, current_monkey, factor) do
    # Assign item
    new_worry_level = calculate_worry_level(current_monkey, item_worry_level, factor)
    destination_monkey_id = find_destination(new_worry_level, current_monkey)
    {destination_monkey_id, new_worry_level}
  end

  defp calculate_worry_level(current_monkey, item_worry_level, factor) do
    new_item_worry_level = item_worry_level |> current_monkey.operation.()

    case factor do
      :by_three ->
        floor(new_item_worry_level / 3)

      _ ->
        rem(new_item_worry_level, factor)
    end
  end

  defp find_destination(worry_level, monkey) do
    if rem(worry_level, monkey.test_factor) == 0 do
      monkey.true_destination
    else
      monkey.false_destination
    end
  end

  defp build_new_items(items) do
    items
    |> Enum.group_by(&elem(&1, 0))
    |> Enum.reduce(%{}, fn {id, items}, acc ->
      new_items = Enum.map(items, &elem(&1, 1))
      Map.put(acc, id, new_items)
    end)
  end

  defp fetch_result(monkeys) do
    monkeys
    |> Enum.map(fn {_, monkey} -> monkey.inspects end)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.reduce(&(&1 * &2))
  end

  @rounds_two 10_000

  @spec part_two(String.t()) :: integer
  def part_two(file_path) do
    monkeys = file_path |> parse_file()
    factor = compute_factor(monkeys)

    1..@rounds_two
    |> Enum.reduce(monkeys, &play_round(&1, &2, factor))
    |> fetch_result()
  end

  ### Helpers

  defp parse_file(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.chunk_every(7)
    |> Enum.map(&Monkey.new(&1))
    |> Map.new(fn monkey ->
      {monkey.id, monkey}
    end)
  end
end
