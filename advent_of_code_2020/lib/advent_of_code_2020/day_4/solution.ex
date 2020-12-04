defmodule AdventOfCode2020.Day4.Solution do
  @moduledoc """
  You arrive at the airport only to realize that you grabbed your North Pole Credentials instead of your passport. While these documents are extremely similar, North Pole Credentials aren't issued by a country and therefore aren't actually valid documentation for travel in most of the world.

  It seems like you're not the only one having problems, though; a very long line has formed for the automatic passport scanners, and the delay could upset your travel itinerary.

  Due to some questionable network security, you realize you might be able to solve both of these problems at the same time.

  The automatic passport scanners are slow because they're having trouble detecting which passports have all required fields.

  Passport data is validated in batch files (your puzzle input). Each passport is represented as a sequence of key:value pairs separated by spaces or newlines. Passports are separated by blank lines.

  The first passport is valid - all eight fields are present. The second passport is invalid - it is missing hgt (the Height field).

  The third passport is interesting; the only missing field is cid, so it looks like data from North Pole Credentials, not a passport at all! Surely, nobody would mind if you made the system temporarily ignore missing cid fields. Treat this "passport" as valid.

  The fourth passport is missing two fields, cid and byr. Missing cid is fine, but missing any other field is not, so this passport is invalid.

  According to the above rules, your improved system would report 2 valid passports.
  """
  @type file_path :: String.t()

  @attributes ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid", "cid"]
  @optional_attribute ["cid"]
  @required_attributes @attributes -- @optional_attribute

  @doc """
  Count the number of valid passports - those that have all required fields. Treat cid as optional. In your batch file, how many passports are valid?
  """
  @spec part_one(file_path) :: integer
  def part_one(file_path) do
    file_path
    |> File.read!()
    |> String.split(~r{(\n\n)+})
    |> Enum.reduce(0, &count_passports_with_all_fields/2)
  end

  defp count_passports_with_all_fields(passport_line, acc) do
    if all_fields_present?(passport_line) do
      acc + 1
    else
      acc
    end
  end

  defp all_fields_present?(passport_line) do
    Enum.all?(@required_attributes, &(passport_line =~ &1))
  end

  @spec part_two(file_path) :: integer
  def part_two(file_path) do
    file_path
    |> File.read!()
    |> String.split(~r{(\n\n)+})
    |> Enum.filter(&all_fields_present?/1)
    |> Enum.reduce(0, &count_passports_with_valid_fields/2)
  end

  defp count_passports_with_valid_fields(passport_line, acc) do
    passport_data = String.split(passport_line, ~r{(\n|\s)}) |> Enum.map(&String.split(&1, ":"))

    if Enum.all?(passport_data, &valid_field?/1) do
      acc + 1
    else
      acc
    end
  end

  defp valid_field?([key | _]) when key in @optional_attribute, do: true

  defp valid_field?(["byr", value | _]) do
    int_value = String.to_integer(value)
    int_value >= 1920 && int_value <= 2002
  end

  defp valid_field?(["iyr", value | _]) do
    int_value = String.to_integer(value)
    int_value >= 2010 && int_value <= 2020
  end

  defp valid_field?(["eyr", value | _]) do
    int_value = String.to_integer(value)
    int_value >= 2020 && int_value <= 2030
  end

  defp valid_field?(["hgt", value | _]) do
    l = String.length(value)

    case String.slice(value, (l - 2)..l) do
      "in" ->
        value = String.slice(value, 0..(l - 3)) |> String.to_integer()
        value >= 59 && value <= 76

      "cm" ->
        value = String.slice(value, 0..(l - 3)) |> String.to_integer()
        value >= 150 && value <= 193

      _ ->
        false
    end
  end

  defp valid_field?(["hcl", value | _]) do
    String.match?(value, ~r/^#[0-9a-f]{6}$/)
  end

  defp valid_field?(["ecl", value | _]) do
    "amb blu brn gry grn hzl oth" =~ value
  end

  defp valid_field?(["pid", value | _]) do
    String.match?(value, ~r/^[0-9]{9}$/)
  end

  defp valid_field?(_), do: false
end
