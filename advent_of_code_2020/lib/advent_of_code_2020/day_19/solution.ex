defmodule AdventOfCode2020.Day19.Solution do
  @moduledoc """
  You land in an airport surrounded by dense forest. As you walk to your high-speed train, the Elves at the Mythical Information Bureau contact you again. They think their satellite has collected an image of a sea monster! Unfortunately, the connection to the satellite is having problems, and many of the messages sent back from the satellite have been corrupted.

  They sent you a list of the rules valid messages should obey and a list of received messages they've collected so far (your puzzle input).

  The rules for valid messages (the top part of your puzzle input) are numbered and build upon each other. For example:

  0: 1 2
  1: "a"
  2: 1 3 | 3 1
  3: "b"

  Some rules, like 3: "b", simply match a single character (in this case, b).

  The remaining rules list the sub-rules that must be followed; for example, the rule 0: 1 2 means that to match rule 0, the text being checked must match rule 1, and the text after the part that matched rule 1 must then match rule 2.

  Some of the rules have multiple lists of sub-rules separated by a pipe (|). This means that at least one list of sub-rules must match. (The ones that match might be different each time the rule is encountered.) For example, the rule 2: 1 3 | 3 1 means that to match rule 2, the text being checked must match rule 1 followed by rule 3 or it must match rule 3 followed by rule 1.

  Fortunately, there are no loops in the rules, so the list of possible matches will be finite. Since rule 1 matches a and rule 3 matches b, rule 2 matches either ab or ba. Therefore, rule 0 matches aab or aba.

  Here's a more interesting example:

  0: 4 1 5
  1: 2 3 | 3 2
  2: 4 4 | 5 5
  3: 4 5 | 5 4
  4: "a"
  5: "b"

  Here, because rule 4 matches a and rule 5 matches b, rule 2 matches two letters that are the same (aa or bb), and rule 3 matches two letters that are different (ab or ba).

  Since rule 1 matches rules 2 and 3 once each in either order, it must match two pairs of letters, one pair with matching letters and one pair with different letters. This leaves eight possibilities: aaab, aaba, bbab, bbba, abaa, abbb, baaa, or babb.

  Rule 0, therefore, matches a (rule 4), then any of the eight options from rule 1, then b (rule 5): aaaabb, aaabab, abbabb, abbbab, aabaab, aabbbb, abaaab, or ababbb.

  The received messages (the bottom part of your puzzle input) need to be checked against the rules so you can determine which are valid and which are corrupted. Including the rules and the messages together, this might look like:

  0: 4 1 5
  1: 2 3 | 3 2
  2: 4 4 | 5 5
  3: 4 5 | 5 4
  4: "a"
  5: "b"

  ababbb
  bababa
  abbbab
  aaabbb
  aaaabbb

  Your goal is to determine the number of messages that completely match rule 0. In the above example, ababbb and abbbab match, but bababa, aaabbb, and aaaabbb do not, producing the answer 2. The whole message must match all of rule 0; there can't be extra unmatched characters in the message. (For example, aaaabbb might appear to match rule 0 above, but it has an extra unmatched b on the end.)
  """
  @type file_path :: String.t()
  @initial_rule 0

  @doc """
  How many messages completely match rule 0?
  """
  @spec part_one(file_path) :: integer
  def part_one(file_path) do
    rules =
      file_path
      |> rules_stream()
      |> Enum.reduce(%{}, &to_ruleset/2)

    valid_messages =
      file_path
      |> messages_stream()
      |> Enum.filter(&valid_message?(&1, rules))
      |> Enum.count()
  end

  defp valid_message?(message, rules) do
    apply_rule_or_ruleset(message, @initial_rule, rules) == []
  end

  # invalid
  defp apply_rule([], _), do: nil
  # maybe valid, depends on rest & up level rule
  defp apply_rule([char | rest], char), do: rest
  # invalid
  defp apply_rule(_, _), do: nil

  defp apply_rule_or_ruleset(nil, _, _), do: nil
  defp apply_rule_or_ruleset([], _, _), do: []

  defp apply_rule_or_ruleset(message, rule, rules) when is_integer(rule) do
    case Map.fetch!(rules, rule) do
      char when is_binary(char) ->
        apply_rule(message, char)

      [ruleset] ->
        apply_rule_or_ruleset(message, ruleset, rules)

      [ruleset1, ruleset2] ->
        case apply_rule_or_ruleset(message, ruleset1, rules) do
          nil -> apply_rule_or_ruleset(message, ruleset2, rules)
          [] -> []
          list -> list
        end
    end
  end

  defp apply_rule_or_ruleset(message, ruleset, rules) do
    Enum.reduce(ruleset, message, fn rule, message ->
      apply_rule_or_ruleset(message, rule, rules)
    end)
  end

  # Builds map with rules
  defp to_ruleset(rule_line, acc) do
    [rule_num, policy] = String.split(rule_line, ": ")

    rules =
      case policy do
        "\"" <> rule ->
          String.replace(rule, "\"", "")

        multi_policy ->
          parse_multi_policy(multi_policy)
      end

    Map.put(acc, String.to_integer(rule_num), rules)
  end

  defp parse_multi_policy(multi_policy) do
    multi_policy
    |> String.split(" | ")
    |> Enum.map(fn rule ->
      rule
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
  end

  @doc """
  As you look over the list of messages, you realize your matching rules aren't quite right. To fix them, completely replace rules 8: 42 and 11: 42 31 with the following:

  8: 42 | 42 8
  11: 42 31 | 42 11 31

  This small change has a big impact: now, the rules do contain loops, and the list of messages they could hypothetically match is infinite. You'll need to determine how these changes affect which messages are valid.

  Fortunately, many of the rules are unaffected by this change; it might help to start by looking at which rules always match the same set of values and how those rules (especially rules 42 and 31) are used by the new versions of rules 8 and 11.

  (Remember, you only need to handle the rules you have; building a solution that could handle any hypothetical combination of rules would be significantly more difficult.)

  For example:

  42: 9 14 | 10 1
  9: 14 27 | 1 26
  10: 23 14 | 28 1
  1: "a"
  11: 42 31
  5: 1 14 | 15 1
  19: 14 1 | 14 14
  12: 24 14 | 19 1
  16: 15 1 | 14 14
  31: 14 17 | 1 13
  6: 14 14 | 1 14
  2: 1 24 | 14 4
  0: 8 11
  13: 14 3 | 1 12
  15: 1 | 14
  17: 14 2 | 1 7
  23: 25 1 | 22 14
  28: 16 1
  4: 1 1
  20: 14 14 | 1 15
  3: 5 14 | 16 1
  27: 1 6 | 14 18
  14: "b"
  21: 14 1 | 1 14
  25: 1 1 | 1 14
  22: 14 14
  8: 42
  26: 14 22 | 1 20
  18: 15 15
  7: 14 5 | 1 21
  24: 14 1

  abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
  bbabbbbaabaabba
  babbbbaabbbbbabbbbbbaabaaabaaa
  aaabbbbbbaaaabaababaabababbabaaabbababababaaa
  bbbbbbbaaaabbbbaaabbabaaa
  bbbababbbbaaaaaaaabbababaaababaabab
  ababaaaaaabaaab
  ababaaaaabbbaba
  baabbaaaabbaaaababbaababb
  abbbbabbbbaaaababbbbbbaaaababb
  aaaaabbaabaaaaababaa
  aaaabbaaaabbaaa
  aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
  babaaabbbaaabaababbaabababaaab
  aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba

  Without updating rules 8 and 11, these rules only match three messages: bbabbbbaabaabba, ababaaaaaabaaab, and ababaaaaabbbaba.

  However, after updating rules 8 and 11, a total of 12 messages match:

  bbabbbbaabaabba
  babbbbaabbbbbabbbbbbaabaaabaaa
  aaabbbbbbaaaabaababaabababbabaaabbababababaaa
  bbbbbbbaaaabbbbaaabbabaaa
  bbbababbbbaaaaaaaabbababaaababaabab
  ababaaaaaabaaab
  ababaaaaabbbaba
  baabbaaaabbaaaababbaababb
  abbbbabbbbaaaababbbbbbaaaababb
  aaaaabbaabaaaaababaa
  aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
  aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba

  After updating rules 8 and 11, how many messages completely match rule 0?
  """
  @spec part_two(file_path) :: integer
  def part_two(_file_path) do
    # Do not have time for that right now.
    nil
  end

  ####################
  # Common functions #
  ####################

  defp rules_stream(file_path) do
    file_path
    |> File.stream!()
    |> Stream.chunk_while([], &chunk_fun/2, &after_fun/1)
    |> Stream.take(1)
    |> Stream.flat_map(& &1)
  end

  defp messages_stream(file_path) do
    file_path
    |> File.stream!()
    |> Stream.chunk_while([], &chunk_fun/2, &after_fun/1)
    |> Stream.take(-1)
    |> Stream.flat_map(&parse_message/1)
  end

  defp parse_message(message) do
    message
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.graphemes/1)
  end

  defp chunk_fun("\n", acc), do: {:cont, Enum.reverse(acc), []}
  defp chunk_fun(el, acc), do: {:cont, [String.trim(el) | acc]}

  defp after_fun([]), do: {:cont, []}
  defp after_fun(acc), do: {:cont, Enum.reverse(acc), []}
end
