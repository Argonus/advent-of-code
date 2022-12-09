defmodule Day02 do
  @moduledoc """
  Documentation for `Day02`.
  """

  @signs ["R", "P", "S"]

  @sign_translation %{
    "A" => "R",
    "X" => "R",
    "B" => "P",
    "Y" => "P",
    "C" => "S",
    "Z" => "S"
  }

  @sign_point %{
    "R" => 1,
    "P" => 2,
    "S" => 3
  }

  @beats %{
    "R" => "S",
    "S" => "P",
    "P" => "R"
  }

  @loses %{
    "R" => "P",
    "P" => "S",
    "S" => "R"
  }

  @spec part_one(String.t()) :: integer
  def part_one(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&parse_line/1)
    |> Stream.map(&parse_signs_one/1)
    |> Stream.map(&play_round/1)
    |> Enum.sum()
  end

  defp parse_line(line) do
    line |> String.trim() |> String.split(" ")
  end

  defp parse_signs_one([elf, player]), do: {decode_sign(elf), decode_sign(player)}

  defp play_round({sign, sign}), do: 3 + get_sign_score(sign)

  defp play_round({elf, player}) do
    if elf == get_beaten_sign(player) do
      6 + get_sign_score(player)
    else
      get_sign_score(player)
    end
  end

  @spec part_two(String.t()) :: integer
  def part_two(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&parse_line/1)
    |> Stream.map(&parse_signs_two/1)
    |> Stream.map(&play_round/1)
    |> Enum.sum()
  end

  @outcome %{
    "X" => :lose,
    "Y" => :draw,
    "Z" => :win
  }

  defp parse_signs_two([elf, player]) do
    elf_sign = decode_sign(elf)
    player_sign = deduct_sign(elf_sign, Map.fetch!(@outcome, player))

    {elf_sign, player_sign}
  end

  defp deduct_sign(elf_sign, :draw), do: elf_sign
  defp deduct_sign(elf_sign, :lose), do: get_beaten_sign(elf_sign)

  defp deduct_sign(elf_sign, :win) do
    Map.fetch!(@loses, elf_sign)
  end

  ### Helpers
  defp decode_sign(sign), do: Map.fetch!(@sign_translation, sign)
  defp get_sign_score(sign), do: Map.fetch!(@sign_point, sign)
  defp get_beaten_sign(sign), do: Map.fetch!(@beats, sign)
end
