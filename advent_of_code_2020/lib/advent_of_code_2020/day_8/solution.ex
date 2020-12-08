defmodule AdventOfCode2020.Day8.Solution do
  @moduledoc """
  Your flight to the major airline hub reaches cruising altitude without incident. While you consider checking the in-flight menu for one of those drinks that come with a little umbrella, you are interrupted by the kid sitting next to you.

  Their handheld game console won't turn on! They ask if you can take a look.

  You narrow the problem down to a strange infinite loop in the boot code (your puzzle input) of the device. You should be able to fix it, but first you need to be able to run the code in isolation.

  The boot code is represented as a text file with one instruction per line of text. Each instruction consists of an operation (acc, jmp, or nop) and an argument (a signed number like +4 or -20).

  acc increases or decreases a single global value called the accumulator by the value given in the argument. For example, acc +7 would increase the accumulator by 7. The accumulator starts at 0. After an acc instruction, the instruction immediately below it is executed next.

  jmp jumps to a new instruction relative to itself. The next instruction to execute is found using the argument as an offset from the jmp instruction; for example, jmp +2 would skip the next instruction, jmp +1 would continue to the instruction immediately below it, and jmp -20 would cause the instruction 20 lines above to be executed next.

  nop stands for No OPeration - it does nothing. The instruction immediately below it is executed next.

  First, the nop +0 does nothing. Then, the accumulator is increased from 0 to 1 (acc +1) and jmp +4 sets the next instruction to the other acc +1 near the bottom. After it increases the accumulator from 1 to 2, jmp -4 executes, setting the next instruction to the only acc +3. It sets the accumulator to 5, and jmp -3 causes the program to continue back at the first acc +1.

  This is an infinite loop: with this sequence of jumps, the program will run forever. The moment the program tries to run any instruction a second time, you know it will never terminate.

  Immediately before the program would run an instruction a second time, the value in the accumulator is 5.
  """

  @type file_path :: String.t()

  defmodule State do
    @moduledoc """
    State of loop with default values
    """
    defstruct acc: 0, index: 0, executed: []
  end

  @doc """
  Run your copy of the boot code. Immediately before any instruction is executed a second time, what value is in the accumulator?
  """
  @spec part_one(file_path) :: integer
  def part_one(file_path) do
    state = %State{
      acc: 0,
      index: 0,
      executed: []
    }

    file_path
    |> file_to_map()
    |> check_loop(state)
    |> Map.fetch!(:acc)
  end

  defp file_to_map(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&parse_line(&1))
    |> Enum.with_index()
    |> Enum.into(%{}, fn {line, index} ->
      {index, line}
    end)
  end

  defp parse_line(line) do
    [key, value] = line |> String.trim() |> String.split(" ")
    [key, String.to_integer(value)]
  end

  defp check_loop(data_map, state = %State{index: index, executed: executed}) do
    if Enum.member?(executed, index) do
      state
    else
      check_loop(data_map, new_state(data_map, state))
    end
  end

  defp new_state(data_map, %State{index: index, acc: acc, executed: executed}) do
    case Map.get(data_map, index) do
      ["acc", value] ->
        %State{index: index + 1, acc: acc + value, executed: [index | executed]}

      ["jmp", value] ->
        %State{index: index + value, acc: acc, executed: [index | executed]}

      ["nop", _] ->
        %State{index: index + 1, acc: acc, executed: [index | executed]}
    end
  end

  @doc """
  Somewhere in the program, either a jmp is supposed to be a nop, or a nop is supposed to be a jmp. (No acc instructions were harmed in the corruption of this boot code.)

  The program is supposed to terminate by attempting to execute an instruction immediately after the last instruction in the file. By changing exactly one jmp or nop, you can repair the boot code and make it terminate correctly.

  If you change the first instruction from nop +0 to jmp +0, it would create a single-instruction infinite loop, never leaving that instruction. If you change almost any of the jmp instructions, the program will still eventually find another jmp instruction and loop forever.

  After the last instruction (acc +6), the program terminates by attempting to run the instruction below the last instruction in the file. With this change, after the program terminates, the accumulator contains the value 8 (acc +1, acc +1, acc +6).

  Fix the program so that it terminates normally by changing exactly one jmp (to nop) or nop (to jmp). What is the value of the accumulator after the program terminates?
  """
  @spec part_two(file_path) :: integer
  def part_two(file_path) do
    data = file_to_map(file_path)
    brute_force_check({data, data}, nil)
  end

  defp brute_force_check({data_to_check, data}, index_to_change) do
    case do_check_without_loop(data_to_check, %State{}) do
      {:ok, acc} ->
        acc

      {:error, _} ->
        new_data = transform_data(data, index_to_change)
        new_index = if is_nil(index_to_change), do: 0, else: index_to_change + 1
        brute_force_check({new_data, data}, new_index)
    end
  end

  defp transform_data(data, nil), do: data

  defp transform_data(data, index_to_change) do
    new_value = Map.fetch!(data, index_to_change) |> new_value()
    Map.put(data, index_to_change, new_value)
  end

  defp new_value(["jmp", value]), do: ["nop", value]
  defp new_value(["nop", value]), do: ["jmp", value]
  defp new_value(data), do: data

  defp do_check_without_loop(data, state = %State{index: index, acc: acc, executed: executed}) do
    cond do
      Enum.member?(executed, index) ->
        {:error, state}

      index < map_size(data) - 1 ->
        do_check_without_loop(data, new_state(data, state))

      true ->
        {:ok, acc}
    end
  end
end
