defmodule AdventOfCode2020.Day2.Solution do
  @moduledoc """
  Your flight departs in a few days from the coastal airport; the easiest way down to the coast from here is via toboggan.

  The shopkeeper at the North Pole Toboggan Rental Shop is having a bad day. "Something's wrong with our computers; we can't log in!" You ask if you can take a look.

  Their password database seems to be a little corrupted: some of the passwords wouldn't have been allowed by the Official Toboggan Corporate Policy that was in effect when they were chosen.

  To try to debug the problem, they have created a list (your puzzle input) of passwords (according to the corrupted database) and the corporate policy when that password was set.
  """

  @type file_path :: String.t()

  @doc """
  Each line gives the password policy and then the password. The password policy indicates the lowest and highest number of times a given letter must appear for the password to be valid. For example, 1-3 a means that the password must contain a at least 1 time and at most 3 times.

  In the above example, 2 passwords are valid. The middle password, cdefg, is not; it contains no instances of b, but needs at least 1. The first and third passwords are valid: they contain one a or nine c, both within the limits of their respective policies.
  """
  @spec part_one(file_path) :: integer
  def part_one(file_path) do
    file_path
    |> File.stream!()
    |> Enum.reduce(0, &count_passwords_with_old_policy/2)
  end

  defp count_passwords_with_old_policy(password_line, acc) do
    {range, lookup_char, password} = build_data(password_line)
    password_chars_count = password |> String.graphemes() |> group_by_char()
    [min, max] = range |> String.split("-") |> Enum.map(&String.to_integer(&1))

    case Map.get(password_chars_count, lookup_char) do
      nil ->
        acc

      value ->
        if value >= min && value <= max do
          acc + 1
        else
          acc
        end
    end
  end

  defp build_data(password_line) do
    [password_policy, password] = password_line |> String.trim() |> String.split(": ")
    [range, char] = String.split(password_policy, " ")
    {range, char, password}
  end

  defp group_by_char(char_list) do
    Enum.reduce(char_list, %{}, fn char, acc ->
      Map.update(acc, char, 1, &(&1 + 1))
    end)
  end

  @spec part_two(file_path) :: integer
  def part_two(file_path) do
    file_path
    |> File.stream!()
    |> Enum.reduce(0, &count_passwords_with_new_policy/2)
  end

  defp count_passwords_with_new_policy(password_line, acc) do
    {range, lookup_char, password} = build_data(password_line)
    password_chars = String.graphemes(password)

    [pos1, pos2] = range |> String.split("-") |> Enum.map(&String.to_integer(&1))

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
