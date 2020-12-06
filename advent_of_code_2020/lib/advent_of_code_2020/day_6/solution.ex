defmodule AdventOfCode2020.Day6.Solution do
  @moduledoc """
  As your flight approaches the regional airport where you'll switch to a much larger plane, customs declaration forms are distributed to the passengers.

  The form asks a series of 26 yes-or-no questions marked a through z. All you need to do is identify the questions for which anyone in your group answers "yes". Since your group is just you, this doesn't take very long.

  However, the person sitting next to you seems to be experiencing a language barrier and asks if you can help. For each of the people in their group, you write down the questions for which they answer "yes", one per line. For example:

  In this group, there are 6 questions to which anyone answered "yes": a, b, c, x, y, and z. (Duplicate answers to the same question don't count extra; each question counts at most once.)

  Another group asks for your help, then another, and eventually you've collected answers from every group on the plane (your puzzle input). Each group's answers are separated by a blank line, and within each group, each person's answers are on a single line. For example:
  """

  @type file_path :: String.t()

  @doc """
  This list represents answers from five groups:

  The first group contains one person who answered "yes" to 3 questions: a, b, and c.
  The second group contains three people; combined, they answered "yes" to 3 questions: a, b, and c.
  The third group contains two people; combined, they answered "yes" to 3 questions: a, b, and c.
  The fourth group contains four people; combined, they answered "yes" to only 1 question, a.
  The last group contains one person who answered "yes" to only 1 question, b.
  In this example, the sum of these counts is 3 + 3 + 3 + 1 + 1 = 11.

  For each group, count the number of questions to which anyone answered "yes". What is the sum of those counts?
  """
  @spec part_one(file_path) :: integer
  def part_one(file_path) do
    file_path
    |> chunk_into_groups()
    |> Stream.map(&count_yes_answers_in_group/1)
    |> Enum.sum()
  end

  defp chunk_into_groups(file_path) do
    file_path
    |> File.stream!()
    |> Stream.chunk_while([], &chunk_fun/2, &after_fun/1)
  end

  defp chunk_fun("\n", acc), do: {:cont, acc, []}
  defp chunk_fun(el, acc), do: {:cont, [String.trim(el) | acc]}

  defp after_fun([]), do: {:cont, []}
  defp after_fun(acc), do: {:cont, acc, []}

  defp count_yes_answers_in_group(group) do
    group
    |> Enum.flat_map(&String.graphemes(&1))
    |> Enum.uniq()
    |> length()
  end

  @doc """
  As you finish the last group's customs declaration, you notice that you misread one word in the instructions:

  You don't need to identify the questions to which anyone answered "yes"; you need to identify the questions to which everyone answered "yes"!

  This list represents answers from five groups:

  In the first group, everyone (all 1 person) answered "yes" to 3 questions: a, b, and c.
  In the second group, there is no question to which everyone answered "yes".
  In the third group, everyone answered yes to only 1 question, a. Since some people did not answer "yes" to b or c, they don't count.
  In the fourth group, everyone answered yes to only 1 question, a.
  In the fifth group, everyone (all 1 person) answered "yes" to 1 question, b.
  In this example, the sum of these counts is 3 + 0 + 1 + 1 + 1 = 6.

  For each group, count the number of questions to which everyone answered "yes". What is the sum of those counts?
  """

  @spec part_two(file_path) :: integer
  def part_two(file_path) do
    file_path
    |> chunk_into_groups()
    |> Stream.map(&count_all_yes_answers_in_group/1)
    |> Enum.sum()
  end

  defp count_all_yes_answers_in_group(group) do
    group
    |> Enum.map(&to_map_set/1)
    |> Enum.reduce(nil, &merge_maps_sets/2)
    |> MapSet.size()
  end

  defp to_map_set(group_element) do
    group_element
    |> String.graphemes()
    |> MapSet.new()
  end

  defp merge_maps_sets(map_set, nil), do: map_set
  defp merge_maps_sets(map_set, acc), do: MapSet.intersection(map_set, acc)
end
