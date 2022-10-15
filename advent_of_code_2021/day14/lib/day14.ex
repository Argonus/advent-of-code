defmodule Day14 do
  @moduledoc """
  The incredible pressures at this depth are starting to put a strain on your submarine.
  The submarine has polymerization equipment that would produce suitable materials to reinforce the submarine,
  and the nearby volcanically-active caves should even have the necessary input elements in sufficient quantities.

  The submarine manual contains instructions for finding the optimal polymer formula; specifically, it offers a polymer
  template and a list of pair insertion rules (your puzzle input). You just need to work out what polymer would result
  after repeating the pair insertion process a few times.

  The first line is the polymer template - this is the starting point of the process.

  The following section defines the pair insertion rules.
  A rule like AB -> C means that when elements A and B are immediately adjacent, element C should be inserted between them.
  These insertions all happen simultaneously.

  So, starting with the polymer template NNCB, the first step simultaneously considers all three pairs:

  - The first pair (NN) matches the rule NN -> C, so element C is inserted between the first N and the second N.
  - The second pair (NC) matches the rule NC -> B, so element B is inserted between the N and the C.
  - The third pair (CB) matches the rule CB -> H, so element H is inserted between the C and the B.

  Note that these pairs overlap: the second element of one pair is the first element of the next pair.
  Also, because all pairs are considered simultaneously, inserted elements are not considered to be part of a pair until the next step.

  Template:     NNCB
  After step 1: NCNBCHB
  After step 2: NBCCNBBBCBHCB
  After step 3: NBBBCNCCNBBNBNBBCHBHHBCHB
  After step 4: NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB
  """

  @doc """
  This polymer grows quickly. After step 5, it has length 97; After step 10, it has length 3073.
  After step 10, B occurs 1749 times, C occurs 298 times, H occurs 161 times, and N occurs 865 times;
  taking the quantity of the most common element (B, 1749) and subtracting the quantity of the
  least common element (H, 161) produces 1749 - 161 = 1588.

  Apply 10 steps of pair insertion to the polymer template and find the most and least common elements in the result.
  What do you get if you take the quantity of the most common element and subtract the quantity of the least common element?
  """

  @spec part_one(String.t()) :: integer
  def part_one(file_path) do
    file_path
    |> parse_file()
    |> apply_pairs(10)
    |> Map.values()
    |> Enum.min_max()
    |> calculate_result()
  end

  defp apply_pairs({polymer, polymer_pairs, pair_rules}, reps) do
    do_apply_pairs(polymer, polymer_pairs, pair_rules, reps)
  end

  defp do_apply_pairs(polymer, _, _, 0), do: polymer

  defp do_apply_pairs(polymer, polymer_pairs, pair_rules, reps) do
    occurrences =
      Enum.reduce(pair_rules, [], fn {pair, _}, acc ->
        [{pair, Map.fetch!(polymer_pairs, pair)} | acc]
      end)

    new_polymer =
      Enum.reduce(occurrences, polymer, fn {pair, c}, acc ->
        letter = Map.fetch!(pair_rules, pair)

        Map.update(acc, letter, c, fn existing_value -> existing_value + c end)
      end)

    new_polymer_pairs =
      Enum.reduce(occurrences, polymer_pairs, fn {pair, c}, acc ->
        new_letter = Map.fetch!(pair_rules, pair)
        [l1, l2] = String.split(pair, "", trim: true)

        acc
        |> Map.update!(pair, fn value -> value - c end)
        |> Map.update!("#{l1}#{new_letter}", fn value -> value + c end)
        |> Map.update!("#{new_letter}#{l2}", fn value -> value + c end)
      end)

    do_apply_pairs(new_polymer, new_polymer_pairs, pair_rules, reps - 1)
  end

  defp calculate_result({min, max}), do: max - min

  defp parse_file(file_path) do
    [raw_polymer, raw_pairs] = file_path |> File.read!() |> String.split("\n\n")
    pairs = parse_pairs(raw_pairs)

    {parse_polymer(raw_polymer), parse_polymer_pairs(raw_polymer, pairs), pairs}
  end

  defp parse_polymer(polymer) do
    polymer |> String.graphemes() |> Enum.frequencies()
  end

  defp parse_polymer_pairs(polymer, pairs) do
    init_polymer_pairs =
      polymer
      |> String.graphemes()
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(&Enum.join(&1, ""))
      |> Enum.frequencies()

    pairs |> Enum.map(fn {k, _v} -> {k, 0} end) |> Enum.into(%{}) |> Map.merge(init_polymer_pairs)
  end

  defp parse_pairs(pairs) do
    pairs
    |> String.split("\n", trim: true)
    |> Enum.map(fn pair ->
      [k, v] = String.split(pair, " -> ", trim: true)
      {k, v}
    end)
    |> Enum.into(%{})
  end

  @doc """
  The resulting polymer isn't nearly strong enough to reinforce the submarine.
  You'll need to run more steps of the pair insertion process; a total of 40 steps should do it.

  In the above example, the most common element is B (occurring 2192039569602 times) and the least common
  element is H (occurring 3849876073 times); subtracting these produces 2188189693529.

  Apply 40 steps of pair insertion to the polymer template and find the most and least common elements in the result.
  What do you get if you take the quantity of the most common element and subtract the quantity of the least common element?
  """
  @spec part_two(String.t()) :: integer
  def part_two(file_path) do
    file_path
    |> parse_file()
    |> apply_pairs(40)
    |> Map.values()
    |> Enum.min_max()
    |> calculate_result()
  end
end
