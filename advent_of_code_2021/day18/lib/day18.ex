defmodule Day18 do
  @moduledoc """
  You descend into the ocean trench and encounter some snailfish.
  They say they saw the sleigh keys! They'll even tell you which direction the keys went if you help one of the smaller
  snailfish with his math homework.

  Snailfish numbers aren't like regular numbers. Instead, every snailfish number is a pair - an ordered list of two elements.
  Each element of the pair can be either a regular number or another pair.

  Pairs are written as [x,y], where x and y are the elements within the pair.
  Here are some example snailfish numbers, one snailfish number per line:

  Pairs are written as [x,y], where x and y are the elements within the pair.
  Here are some example snailfish numbers, one snailfish number per line:

    This snailfish homework is about addition. To add two snailfish numbers,
  form a pair from the left and right parameters of the addition operator.
  For example, [1,2] + [[3,4],5] becomes [[1,2],[[3,4],5]]

  There's only one problem: snailfish numbers must always be reduced, and the process of adding two snailfish numbers
  can result in snailfish numbers that need to be reduced.

  To reduce a snailfish number, you must repeatedly do the first action in this list that applies to the snailfish number:

  - If any pair is nested inside four pairs, the leftmost such pair explodes.
  - If any regular number is 10 or greater, the leftmost such regular number splits.

  Once no action in the above list applies, the snailfish number is reduced.

  During reduction, at most one action applies, after which the process returns to the top of the list of actions.
  For example, if split produces a pair that meets the explode criteria, that pair explodes before other splits occur.

  To explode a pair, the pair's left value is added to the first regular number to the left of the exploding pair (if any),
  and the pair's right value is added to the first regular number to the right of the exploding pair (if any).
  Exploding pairs will always consist of two regular numbers. Then, the entire exploding pair is replaced with the regular number 0.

  - [[[[[9,8],1],2],3],4] becomes [[[[0,9],2],3],4] (the 9 has no regular number to its left, so it is not added to any regular number).
  - [7,[6,[5,[4,[3,2]]]]] becomes [7,[6,[5,[7,0]]]] (the 2 has no regular number to its right, and so it is not added to any regular number).
  - [[6,[5,[4,[3,2]]]],1] becomes [[6,[5,[7,0]]],3].
  - [[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]] becomes [[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]] (the pair [3,2] is unaffected because the pair [7,3] is further to the left; [3,2] would explode on the next action).
  - [[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]] becomes [[3,[2,[8,0]]],[9,[5,[7,0]]]].

  To split a regular number, replace it with a pair; the left element of the pair should be the regular number divided
  by two and rounded down, while the right element of the pair should be the regular number divided by two and rounded up.
  For example, 10 becomes [5,5], 11 becomes [5,6], 12 becomes [6,6], and so on.

  Here is the process of finding the reduced result of [[[[4,3],4],4],[7,[[8,4],9]]] + [1,1]:

  - after addition: [[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]
  - after explode:  [[[[0,7],4],[7,[[8,4],9]]],[1,1]]
  - after explode:  [[[[0,7],4],[15,[0,13]]],[1,1]]
  - after split:    [[[[0,7],4],[[7,8],[0,13]]],[1,1]]
  - after split:    [[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]
  - after explode:  [[[[0,7],4],[[7,8],[6,0]]],[8,1]]

  Once no reduce actions apply, the snailfish number that remains is the actual result of the addition operation:
  [[[[0,7],4],[[7,8],[6,0]]],[8,1]].
  """

  @doc """
  The homework assignment involves adding up a list of snailfish numbers (your puzzle input).
  The snailfish numbers are each listed on a separate line.
  Add the first snailfish number and the second, then add that result and the third, then add that result and the fourth,
  and so on until all numbers in the list have been used once.
  """
  @spec part_one(String.t()) :: integer
  def part_one(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&parse_line/1)
    |> Enum.reduce(nil, &add_lines/2)
    |> magnitude()
  end

  defp add_lines(new_number, nil), do: new_number

  defp add_lines(new_number, previous_number) do
    reduce_number([previous_number, new_number])
  end

  def reduce_number(number) do
    case explode_number(number, 0) do
      {:exploded, number, _, _} ->
        reduce_number(number)

      {_, number, _, _} ->
        case split(number) do
          {:split, number} -> reduce_number(number)
          {_, number} -> number
        end
    end
  end

  defp explode_number([left_number, right_number], 4),
    do: {:exploded, 0, left_number, right_number}

  defp explode_number([left_number, right_number], c) do
    case explode_number(left_number, c + 1) do
      {:misfire, left_number, x, y} ->
        #        IO.inspect("Misfire in round #{c}")
        #        IO.inspect("Left Number: #{inspect(left_number)}, Right Number: #{inspect(right_number)}")
        #        IO.inspect("X Number: #{inspect(x)}, Y Number: #{inspect(y)}")

        case explode_number(right_number, c + 1) do
          {:exploded, right_number, x, y} when not is_nil(x) ->
            {:exploded, [increment(left_number, x, :right), right_number], nil, y}

          {result, right_number, x, y} ->
            {result, [left_number, right_number], x, y}
        end

      {:exploded, left_number, x, y} ->
        #        IO.inspect("Explode in round #{c}")
        #        IO.inspect("Left Number: #{inspect(left_number)}, Right Number: #{inspect(right_number)}")
        #        IO.inspect("X Number: #{inspect(x)}, Y Number: #{inspect(y)}")

        if is_nil(y) do
          {:exploded, [left_number, right_number], x, y}
        else
          {:exploded, [left_number, increment(right_number, y, :left)], x, nil}
        end
    end
  end

  defp explode_number(num, _), do: {:misfire, num, nil, nil}

  # Go through list until find num to add. When input is left part, vector is right, when right vectors is left.
  defp increment(num_or_list, to_add, vector)
  defp increment([l, r], v, :left), do: [increment(l, v, :left), r]
  defp increment([l, r], v, :right), do: [l, increment(r, v, :right)]
  defp increment(num, v, _), do: num + v

  defp split([left_number, right_number]) do
    case split(left_number) do
      {:split, left_number} ->
        {:split, [left_number, right_number]}

      {res, left_number} ->
        {res, right_number} = split(right_number)
        {res, [left_number, right_number]}
    end
  end

  defp split(num) when num >= 10, do: {:split, [split_left(num), split_right(num)]}
  defp split(num), do: {:next, num}

  defp split_left(num), do: trunc(num / 2)
  defp split_right(num), do: num - trunc(num / 2)

  defp magnitude([left_number, right_number]),
    do: 3 * magnitude(left_number) + 2 * magnitude(right_number)

  defp magnitude(num), do: num

  defp parse_line(line) do
    line
    |> String.trim()
    |> Code.eval_string()
    |> Kernel.elem(0)
  end

  @doc """
  You notice a second question on the back of the homework assignment:

  What is the largest magnitude you can get from adding only two of the snailfish numbers?

  Note that snailfish addition is not commutative - that is, x + y and y + x can produce different results.

  """
  @spec part_two(String.t()) :: integer
  def part_two(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&parse_line/1)
    |> Enum.to_list()
    |> calculate_max_magnitude()
    |> Enum.max()
  end

  defp calculate_max_magnitude(numbers) do
    for n1 <- numbers, n2 <- numbers, n1 != n2 do
      add_lines(n1, n2) |> magnitude()
    end
  end
end
