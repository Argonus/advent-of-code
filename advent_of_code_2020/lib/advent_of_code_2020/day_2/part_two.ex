defmodule AdventOfCode2020.Day2.PartTwo do
  @moduledoc """
  While it appears you validated the passwords correctly, they don't seem to be what the Official Toboggan Corporate Authentication System is expecting.

  The shopkeeper suddenly realizes that he just accidentally explained the password policy rules from his old job at the sled rental place down the street! The Official Toboggan Corporate Policy actually works a little differently.

  Each policy actually describes two positions in the password, where 1 means the first character, 2 means the second character, and so on. (Be careful; Toboggan Corporate Policies have no concept of "index zero"!) Exactly one of these positions must contain the given letter. Other occurrences of the letter are irrelevant for the purposes of policy enforcement.

  How many passwords are valid according to the new interpretation of the policies?
  """

  @type file_path :: String.t()

  @spec find(file_path) :: integer
  def find(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&build_data/1)
    |> Enum.reduce(0, &check_and_reduce_password/2)
  end

  defp build_data(line) do
    [password_policy, password] = line |> String.trim() |> String.split(": ")
    [range, char] = String.split(password_policy, " ")
    %{range: range, char: char, password: password}
  end

  defp check_and_reduce_password(password_data, acc) do
    lookup_char = Map.fetch!(password_data, :char)
    password_chars = password_data |> Map.fetch!(:password) |> String.graphemes()

    [str_min, str_max] = password_data |> Map.fetch!(:range) |> String.split("-")
    {pos1, _} = Integer.parse(str_min)
    {pos2, _} = Integer.parse(str_max)

    lookup_pos1 = fetch_char(password_chars, pos1)
    lookup_pos2 = fetch_char(password_chars, pos2)

    if boolean_xor(lookup_pos1 == lookup_char, lookup_pos2 == lookup_char) do
      acc + 1
    else
      acc
    end
  end

  defp fetch_char(char_list, pos) do
    case Enum.fetch(char_list, pos - 1) do
      {:ok, char} -> char
      _ -> nil
    end
  end

  defp boolean_xor(true, true), do: false
  defp boolean_xor(false, false), do: false
  defp boolean_xor(_, _), do: true
end
