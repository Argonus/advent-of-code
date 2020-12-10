defmodule AdventOfCode2020.Day10.Solution do
  @moduledoc """
  Patched into the aircraft's data port, you discover weather forecasts of a massive tropical storm. Before you can figure out whether it will impact your vacation plans, however, your device suddenly turns off!

  Its battery is dead.

  You'll need to plug it in. There's only one problem: the charging outlet near your seat produces the wrong number of jolts. Always prepared, you make a list of all of the joltage adapters in your bag.

  Each of your joltage adapters is rated for a specific output joltage (your puzzle input). Any given adapter can take an input 1, 2, or 3 jolts lower than its rating and still produce its rated output joltage.

  In addition, your device has a built-in joltage adapter rated for 3 jolts higher than the highest-rated adapter in your bag. (If your adapter list were 3, 9, and 6, your device's built-in adapter would be rated for 12 jolts.)

  Treat the charging outlet near your seat as having an effective joltage rating of 0.

  Since you have some time to kill, you might as well test all of your adapters. Wouldn't want to get to your resort and realize you can't even charge your device!

  If you use every adapter in your bag at once, what is the distribution of joltage differences between the charging outlet, the adapters, and your device?

  For example, suppose that in your bag, you have adapters with the following joltage ratings:

  With these adapters, your device's built-in joltage adapter would be rated for 19 + 3 = 22 jolts, 3 higher than the highest-rated adapter.

  Because adapters can only connect to a source 1-3 jolts lower than its rating, in order to use every adapter, you'd need to choose them like this:

  - The charging outlet has an effective rating of 0 jolts, so the only adapters that could connect to it directly would need to have a joltage rating of 1, 2, or 3 jolts. Of these, only one you have is an adapter rated 1 jolt (difference of 1)
  - From your 1-jolt rated adapter, the only choice is your 4-jolt rated adapter (difference of 3).
  - From the 4-jolt rated adapter, the adapters rated 5, 6, or 7 are valid choices. However, in order to not skip any adapters, you have to pick the adapter rated 5 jolts (difference of 1)
  - Similarly, the next choices would need to be the adapter rated 6 and then the adapter rated 7 (with difference of 1 and 1)
  - The only adapter that works with the 7-jolt rated adapter is the one rated 10 jolts (difference of 3)
  - From 10, the choices are 11 or 12; choose 11 (difference of 1) and then 12 (difference of 1).
  - After 12, only valid adapter has a rating of 15 (difference of 3), then 16 (difference of 1), then 19 (difference of 3)
  - Finally, your device's built-in adapter is always 3 higher than the highest adapter, so its rating is 22 jolts (always a difference of 3)
  """

  @type file_path :: String.t()

  @doc """
  Find a chain that uses all of your adapters to connect the charging outlet to your device's built-in adapter and count the joltage differences between the charging outlet, the adapters, and your device. What is the number of 1-jolt differences multiplied by the number of 3-jolt differences?
  """

  @spec part_one(file_path) :: integer
  def part_one(file_path) do
    accumulator = %{
      diff_1: 0,
      diff_2: 0,
      diff_3: 0,
      prev_jolt: nil
    }

    file_path
    |> build_adapter_jolts_list()
    |> Enum.reduce(accumulator, &count_diffs/2)
    |> calculate_result()
  end

  defp build_adapter_jolts_list(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&parse_line/1)
    |> Enum.sort()
    |> add_outlet()
    |> add_device()
  end

  defp parse_line(line), do: line |> String.trim() |> String.to_integer()

  defp add_outlet(adapter_jolts), do: [0 | adapter_jolts]

  defp add_device(adapter_jolts) do
    device = Enum.max(adapter_jolts) + 3
    adapter_jolts ++ [device]
  end

  defp count_diffs(adapter, acc = %{prev_jolt: nil}), do: %{acc | prev_jolt: adapter}

  defp count_diffs(adapter, acc = %{prev_jolt: prev_jolt}) do
    acc
    |> Map.update!(diff(adapter, prev_jolt), &(&1 + 1))
    |> Map.put(:prev_jolt, adapter)
  end

  defp diff(new_jolt, prev_jolt) when new_jolt - prev_jolt == 1, do: :diff_1
  defp diff(new_jolt, prev_jolt) when new_jolt - prev_jolt == 2, do: :diff_2
  defp diff(new_jolt, prev_jolt) when new_jolt - prev_jolt == 3, do: :diff_3

  defp calculate_result(%{diff_1: diff_1, diff_3: diff_3}), do: diff_1 * diff_3

  @doc """
  To completely determine whether you have enough adapters, you'll need to figure out how many different ways they can be arranged. Every arrangement needs to connect the charging outlet to your device. The previous rules about when adapters can successfully connect still apply.

  The first example above (the one that starts with 16, 10, 15) supports the following arrangements:

  (0), 1, 4, 5, 6, 7, 10, 11, 12, 15, 16, 19, (22)
  (0), 1, 4, 5, 6, 7, 10, 12, 15, 16, 19, (22)
  (0), 1, 4, 5, 7, 10, 11, 12, 15, 16, 19, (22)
  (0), 1, 4, 5, 7, 10, 12, 15, 16, 19, (22)
  (0), 1, 4, 6, 7, 10, 11, 12, 15, 16, 19, (22)
  (0), 1, 4, 6, 7, 10, 12, 15, 16, 19, (22)
  (0), 1, 4, 7, 10, 11, 12, 15, 16, 19, (22)
  (0), 1, 4, 7, 10, 12, 15, 16, 19, (22)

  (The charging outlet and your device's built-in adapter are shown in parentheses.) Given the adapters from the first example, the total number of arrangements that connect the charging outlet to your device is 8.

  In total, this set of adapters can connect the charging outlet to your device in 19208 distinct arrangements.

  You glance back down at your bag and try to remember why you brought so many adapters; there must be more than a trillion valid ways to arrange them! Surely, there must be an efficient way to count the arrangements.

  What is the total number of distinct ways you can arrange the adapters to connect the charging outlet to your device?
  """
  @spec part_two(file_path) :: integer
  def part_two(file_path) do
    accumulator = %{0 => 1}

    file_path
    |> build_adapter_jolts_list()
    |> Enum.reduce(accumulator, &calculate_combinations/2)
    |> Map.values()
    |> Enum.max()
  end

  defp calculate_combinations(0, accumulator), do: accumulator

  defp calculate_combinations(adapter, accumulator) do
    adapter_1 = Map.get(accumulator, adapter - 1, 0)
    adapter_2 = Map.get(accumulator, adapter - 2, 0)
    adapter_3 = Map.get(accumulator, adapter - 3, 0)

    Map.put(accumulator, adapter, adapter_1 + adapter_2 + adapter_3)
  end
end
