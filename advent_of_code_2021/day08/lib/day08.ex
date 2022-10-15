defmodule Day08 do
  @moduledoc """
  You barely reach the safety of the cave when the whale smashes into the cave mouth, collapsing it.
  Sensors indicate another exit to this cave at a much greater depth, so you have no choice but to press on.

  As your submarine slowly makes its way through the cave system, you notice that the four-digit seven-segment displays
  in your submarine are malfunctioning; they must have been damaged during the escape.
  You'll be in a lot of trouble without them, so you'd better figure out what's wrong.

  Each digit of a seven-segment display is rendered by turning on or off any of seven segments named a through g:

    0:      1:      2:      3:      4:
   aaaa    ....    aaaa    aaaa    ....
  b    c  .    c  .    c  .    c  b    c
  b    c  .    c  .    c  .    c  b    c
   ....    ....    dddd    dddd    dddd
  e    f  .    f  e    .  .    f  .    f
  e    f  .    f  e    .  .    f  .    f
   gggg    ....    gggg    gggg    ....

  5:      6:      7:      8:      9:
   aaaa    aaaa    aaaa    aaaa    aaaa
  b    .  b    .  .    c  b    c  b    c
  b    .  b    .  .    c  b    c  b    c
   dddd    dddd    ....    dddd    dddd
  .    f  e    f  .    f  e    f  .    f
  .    f  e    f  .    f  e    f  .    f
   gggg    gggg    ....    gggg    gggg

  So, to render a 1, only segments c and f would be turned on; the rest would be off. To render a 7, only segments a, c, and f would be turned on.

  The problem is that the signals which control the segments have been mixed up on each display.
  The submarine is still trying to display numbers by producing output on signal wires a through g,
  but those wires are connected to segments randomly.
  Worse, the wire/segment connections are mixed up separately for each four-digit display!
  (All of the digits within a display use the same connections, though.)

  So, you might know that only signal wires b and g are turned on, but that doesn't mean segments b and g are turned on:
  the only digit that uses two segments is 1, so it must mean segments c and f are meant to be on.
  With just that information, you still can't tell which wire (b/g) goes to which segment (c/f).
  For that, you'll need to collect more information.

  For each display, you watch the changing signals for a while, make a note of all ten unique signal patterns you see,
  and then write down a single four digit output value (your puzzle input).
  Using the signal patterns, you should be able to work out which pattern corresponds to which digit.

  For example, here is what you might see in a single entry in your notes:
  acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf

  Each entry consists of ten unique signal patterns, a | delimiter, and finally the four digit output value.
  Within an entry, the same wire/segment connections are used (but you don't know what the connections actually are).
  The unique signal patterns correspond to the ten different ways the submarine tries to render a digit using the current
  wire/segment connections. Because 7 is the only digit that uses three segments, dab in the above example means that
  to render a 7, signal lines d, a, and b are on. Because 4 is the only digit that uses four segments, eafb means
  that to render a 4, signal lines e, a, f, and b are on.

  Using this information, you should be able to work out which combination of signal wires corresponds to each of the ten digits.
  Then, you can decode the four digit output value. Unfortunately, in the above example, all of the digits in the output
  value (cdfeb fcadb cdfeb cdbaf) use five segments and are more difficult to deduce.
  """

  @doc """
  Because the digits 1, 4, 7, and 8 each use a unique number of segments, you should be able to tell which combinations
  of signals correspond to those digits. Counting only digits in the output values (the part after | on each line),
  in the above example, there are 26 instances of digits that use a unique number of segments (highlighted above).

  In the output values, how many times do digits 1, 4, 7, or 8 appear?
  """
  @patterns_part_one %{
    1 => 2,
    4 => 4,
    7 => 3,
    8 => 7
  }

  @spec part_one(String.t()) :: integer
  def part_one(file_path) do
    file_path
    |> parse_input()
    |> Stream.map(&parse_line_part_one/1)
    |> Stream.map(&unique_digits/1)
    |> Enum.reduce(0, &count_digits/2)
  end

  defp parse_line_part_one(line) do
    line |> String.split(" | ") |> List.last() |> String.split(" ")
  end

  defp unique_digits(line) do
    patterns = Map.values(@patterns_part_one)
    Enum.filter(line, &Enum.member?(patterns, String.length(&1)))
  end

  defp count_digits([], acc), do: acc

  defp count_digits(digits, acc) do
    acc + length(digits)
  end

  defp parse_input(file_path) do
    file_path |> File.stream!() |> Stream.map(&String.trim/1)
  end

  @doc """
  Through a little deduction, you should now be able to determine the remaining digits. Consider again the first example above:

  acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf

  After some careful analysis, the mapping between signal wires and segments only make sense in the following configuration:

   dddd
  e    a
  e    a
   ffff
  g    b
  g    b
   cccc

  So, the unique signal patterns would correspond to the following digits:

  acedgfb: 8
  cdfbe: 5
  gcdfa: 2
  fbcad: 3
  dab: 7
  cefabd: 9
  cdfgeb: 6
  eafb: 4
  cagedb: 0
  ab: 1

  Then, the four digits of the output value can be decoded:

  cdfeb: 5
  fcadb: 3
  cdfeb: 5
  cdbaf: 3

  Therefore, the output value for this entry is 5353.

  Following this same process for each entry in the second, larger example above, the output value of each entry can be determined:

  fdgacbe cefdb cefbgd gcbe: 8394
  fcgedb cgb dgebacf gc: 9781
  cg cg fdcagb cbg: 1197
  efabcd cedba gadfec cb: 9361
  gecf egdcabf bgf bfgea: 4873
  gebdcfa ecba ca fadegcb: 8418
  cefg dcbef fcge gbcadfe: 4548
  ed bcgafe cdgba cbgef: 1625
  gbdfcae bgc cg cgb: 8717
  fgae cfgab fg bagce: 4315

  Adding all of the output values in this larger example produces 61229.

  For each entry, determine all of the wire/segment connections and decode the four-digit output values.
  What do you get if you add up all of the output values?
  """
  @patterns_part_two %{
    zero: 6,
    one: 2,
    two: 5,
    three: 5,
    four: 4,
    five: 5,
    six: 6,
    seven: 3,
    eight: 7,
    nine: 6
  }

  @spec part_two(String.t()) :: integer
  def part_two(file_path) do
    file_path
    |> parse_input()
    |> Stream.map(&parse_line_part_two/1)
    |> Stream.map(&find_mapping/1)
    |> Stream.map(&decode_value/1)
    |> Enum.sum()
  end

  defp find_mapping({input, output}) do
    # unique patterns
    one = Enum.find(input, &match_pattern?(&1, :one)) |> to_mapset()
    four = Enum.find(input, &match_pattern?(&1, :four)) |> to_mapset()
    seven = Enum.find(input, &match_pattern?(&1, :seven)) |> to_mapset()
    eight = Enum.find(input, &match_pattern?(&1, :eight)) |> to_mapset()

    # maybe patterns
    two_or_three_or_five =
      input |> Enum.filter(&match_patterns?(&1, [:two, :three, :five])) |> Enum.map(&to_mapset/1)

    zero_or_six_or_nine =
      input |> Enum.filter(&match_patterns?(&1, [:zero, :six, :nine])) |> Enum.map(&to_mapset/1)

    # patterns
    # 9 => include 4
    nine = Enum.find(zero_or_six_or_nine, &MapSet.subset?(four, &1))
    zero_or_six = List.delete(zero_or_six_or_nine, nine)
    # 0 => include 7 then six is last one
    zero = Enum.find(zero_or_six, &MapSet.subset?(seven, &1))
    [six] = List.delete(zero_or_six, zero)

    # three = include 7
    three = Enum.find(two_or_three_or_five, &MapSet.subset?(seven, &1))
    two_or_five = List.delete(two_or_three_or_five, three)
    # 5 = 9 include
    five = Enum.find(two_or_five, &MapSet.subset?(&1, nine))
    [two] = List.delete(two_or_five, five)

    pattern = %{
      zero => "0",
      one => "1",
      two => "2",
      three => "3",
      four => "4",
      five => "5",
      six => "6",
      seven => "7",
      eight => "8",
      nine => "9"
    }

    {pattern, output}
  end

  defp decode_value({pattern, output}) do
    output
    |> Enum.map(&to_mapset/1)
    |> Enum.map_join(&find_value(&1, pattern))
    |> String.to_integer()
  end

  defp to_mapset(input) do
    input |> String.graphemes() |> MapSet.new()
  end

  defp find_value(pattern, patterns), do: Map.fetch!(patterns, pattern)

  defp match_patterns?(input, [p | _]) do
    match_pattern?(input, p)
  end

  defp match_pattern?(input, pattern) do
    String.length(input) == Map.fetch!(@patterns_part_two, pattern)
  end

  defp parse_line_part_two(line) do
    [input, output] = line |> String.split(" | ") |> Enum.map(&String.split(&1, " ", trim: true))
    {input, output}
  end
end
