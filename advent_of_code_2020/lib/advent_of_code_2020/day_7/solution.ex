defmodule AdventOfCode2020.Day7.Solution do
  @moduledoc """
  You land at the regional airport in time for your next flight. In fact, it looks like you'll even have time to grab some food: all flights are currently delayed due to issues in luggage processing.

  Due to recent aviation regulations, many rules (your puzzle input) are being enforced about bags and their contents; bags must be color-coded and must contain specific quantities of other color-coded bags. Apparently, nobody responsible for these regulations considered how long they would take to enforce!

  For example, consider the following rules:

  These rules specify the required contents for 9 bag types. In this example, every faded blue bag is empty, every vibrant plum bag contains 11 bags (5 faded blue and 6 dotted black), and so on.

  You have a shiny gold bag. If you wanted to carry it in at least one other bag, how many different bag colors would be valid for the outermost bag? (In other words: how many colors can, eventually, contain at least one shiny gold bag?)

  So, in this example, the number of bag colors that can eventually contain at least one shiny gold bag is 4.
  """

  @type file_path :: String.t()

  @doc """
  How many bag colors can eventually contain at least one shiny gold bag? (The list of rules is quite long; make sure you get all of it.)
  """

  @bag_color "shiny gold"
  @no_other_bag "no other"
  @line_regexp ~r{(\w+ \w+) bags contain (.*)\.}

  @spec part_one(file_path) :: integer
  def part_one(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&String.trim(&1))
    |> Stream.map(&Regex.run(@line_regexp, &1, capture: :all_but_first))
    |> Stream.map(&parse_children/1)
    |> Enum.reduce(%{}, &build_children_parent_map/2)
    |> count_bags_containing([@bag_color], MapSet.new([]))
    |> MapSet.size()
  end

  @bag_regexp ~r{(\w+ \w+) bag}
  defp parse_children([parent, children]) do
    children =
      children
      |> String.split(", ")
      |> Enum.flat_map(&Regex.run(@bag_regexp, &1, capture: :all_but_first))

    [parent, children]
  end

  defp build_children_parent_map([parent, children], acc) do
    Enum.reduce(children, acc, fn child, acc2 ->
      Map.update(acc2, child, [parent], fn current_parent ->
        [parent | current_parent]
      end)
    end)
  end

  defp count_bags_containing(_bags_map, [], acc), do: acc

  defp count_bags_containing(bags_map, [head | tail], acc) do
    case Map.pop(bags_map, head) do
      {nil, new_bags_map} ->
        count_bags_containing(new_bags_map, tail, acc)

      {parents, new_bags_map} ->
        new_acc = MapSet.union(acc, MapSet.new(parents))
        new_queue = tail ++ parents

        count_bags_containing(new_bags_map, new_queue, new_acc)
    end
  end

  @doc """
  How many individual bags are required inside your single shiny gold bag?
  """
  @spec part_two(file_path) :: integer
  def part_two(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&String.trim(&1))
    |> Stream.map(&Regex.run(@line_regexp, &1, capture: :all_but_first))
    |> Enum.reduce(%{}, &parse_children_and_count/2)
    |> count_needed_bags([{@bag_color, 1}], 0)
  end

  @bag_count_regexp ~r{\d+}
  defp parse_children_and_count([parent, children], acc) do
    parsed_children =
      children
      |> String.split(", ")
      |> Enum.reject(&(&1 =~ @no_other_bag))
      |> Enum.map(fn child_line ->
        [child] = Regex.run(@bag_regexp, child_line, capture: :all_but_first)
        [count] = Regex.run(@bag_count_regexp, child_line, capture: :first)

        {child, String.to_integer(count)}
      end)

    Map.put(acc, parent, parsed_children)
  end

  defp count_needed_bags(_, [], acc), do: acc

  defp count_needed_bags(bags_map, [{parent_color, parent_count} | tail], acc) do
    case Map.get(bags_map, parent_color) do
      nil ->
        count_needed_bags(bags_map, tail, acc)

      children ->
        {new_queue, new_acc} =
          Enum.reduce(children, {tail, acc}, fn {child_color, child_count}, {tail_acc, sum_acc} ->
            multi = child_count * parent_count

            new_acc = multi + sum_acc
            new_queue = [{child_color, multi} | tail_acc]

            {new_queue, new_acc}
          end)

        count_needed_bags(bags_map, new_queue, new_acc)
    end
  end
end
