defmodule AdventOfCode2020.Day2.PartOne do
  @moduledoc """
  --- Day 2: Password Philosophy ---
  Your flight departs in a few days from the coastal airport; the easiest way down to the coast from here is via toboggan.

  The shopkeeper at the North Pole Toboggan Rental Shop is having a bad day. "Something's wrong with our computers; we can't log in!" You ask if you can take a look.

  Their password database seems to be a little corrupted: some of the passwords wouldn't have been allowed by the Official Toboggan Corporate Policy that was in effect when they were chosen.

  To try to debug the problem, they have created a list (your puzzle input) of passwords (according to the corrupted database) and the corporate policy when that password was set.

  Each line gives the password policy and then the password. The password policy indicates the lowest and highest number of times a given letter must appear for the password to be valid. For example, 1-3 a means that the password must contain a at least 1 time and at most 3 times.

  In the above example, 2 passwords are valid. The middle password, cdefg, is not; it contains no instances of b, but needs at least 1. The first and third passwords are valid: they contain one a or nine c, both within the limits of their respective policies.

  How many passwords are valid according to their policies?
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

    password_chars_count =
      password_data |> Map.fetch!(:password) |> String.graphemes() |> group_by_char()

    [str_min, str_max] = password_data |> Map.fetch!(:range) |> String.split("-")
    {min, _} = Integer.parse(str_min)
    {max, _} = Integer.parse(str_max)

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

  defp group_by_char(char_list) do
    Enum.reduce(char_list, %{}, fn char, acc ->
      Map.update(acc, char, 1, &(&1 + 1))
    end)
  end
end
