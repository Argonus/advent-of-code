defmodule Day04 do
  @moduledoc """
  You're already almost 1.5km (almost a mile) below the surface of the ocean, already so deep that you can't see any sunlight.
  What you can see, however, is a giant squid that has attached itself to the outside of your submarine.

  Maybe it wants to play bingo?

  Bingo is played on a set of boards each consisting of a 5x5 grid of numbers.
  Numbers are chosen at random, and the chosen number is marked on all boards on which it appears.
  (Numbers may not appear on all boards.)
  If all numbers in any row or any column of a board are marked, that board wins. (Diagonals don't count.)

  The submarine has a bingo subsystem to help passengers (currently, you and the giant squid) pass the time.
  It automatically generates a random order in which to draw numbers and a random set of boards (your puzzle input).
  For example:

  7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

  22 13 17 11  0
  8  2 23  4 24
  21  9 14 16  7
  6 10  3 18  5
  1 12 20 15 19

  3 15  0  2 22
  9 18 13 17  5
  19  8  7 25 23
  20 11 10 24  4
  14 21 16 12  6

  14 21 17 24  4
  10 16 15  9 19
  18  8 23 26 20
  22 11 13  6  5
  2  0 12  3  7

  After the first five numbers are drawn (7, 4, 9, 5, and 11), there are no winners,
  but the boards are marked as follows (shown here adjacent to each other to save space):

  After the next six numbers are drawn (17, 23, 2, 0, 14, and 21), there are still no winners:

  Finally, 24 is drawn:

  At this point, the third board wins because it has at least one complete row or column of marked numbers
  (in this case, the entire top row is marked: 14 21 17 24 4).
  """

  @doc """
  The score of the winning board can now be calculated. Start by finding the sum of all unmarked numbers on that board;
  in this case, the sum is 188.
  Then, multiply that sum by the number that was just called when the board won, 24, to get the final score, 188 * 24 = 4512.
  To guarantee victory against the giant squid, figure out which board will win first. What will your final score be if you choose that board?
  """

  @matrix_size 5

  @spec part_one(String.t()) :: integer
  def part_one(file_path) do
    {numbers, boards} = prepare_input(file_path)

    Enum.reduce_while(numbers, boards, fn num, acc ->
      new_boards_set = Enum.map(acc, &mark_numbers(&1, num))

      case Enum.find(new_boards_set, &is_winner?(&1)) do
        nil ->
          {:cont, new_boards_set}

        board ->
          score = calculate_score(board, num)
          {:halt, score}
      end
    end)
  end

  defp prepare_input(file_path) do
    [num_str | boards_strs] =
      file_path
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Enum.reject(&(&1 == ""))

    numbers = parse_numbers(num_str, ",")
    boards = parse_boards(boards_strs)

    {numbers, boards}
  end

  defp parse_numbers(num_str, delimiter) do
    num_str
    |> String.split(delimiter, trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp parse_boards(boards_strs) do
    boards_strs
    |> Stream.map(&parse_numbers(&1, " "))
    |> Stream.chunk_every(@matrix_size)
    |> Enum.map(&parse_board/1)
  end

  defp parse_board(board) do
    board
    |> Enum.with_index()
    |> Enum.flat_map(fn {board_line, line_idx} ->
      board_line
      |> Enum.with_index()
      |> Enum.map(fn {num, col_idx} ->
        {num, %{x: col_idx, y: line_idx, mark: false}}
      end)
    end)
    |> Enum.into(%{})
  end

  defp mark_numbers(board, number) do
    case Map.get(board, number) do
      nil -> board
      val -> %{board | number => %{val | mark: true}}
    end
  end

  defp is_winner?(board) do
    res =
      board
      |> Enum.map(fn {_, v} -> v end)
      |> Enum.filter(& &1.mark)

    {_, set_x} = Enum.group_by(res, & &1.x) |> Enum.max_by(fn {_, set} -> length(set) end, fn -> {nil, []} end)
    {_, set_y} = Enum.group_by(res, & &1.y) |> Enum.max_by(fn {_, set} -> length(set) end, fn -> {nil, []} end)

    if length(set_x) == @matrix_size || length(set_y) == @matrix_size, do: true, else: false
  end

  defp calculate_score(board, num) do
    sum =
      Enum.reduce(board, 0, fn {val, grid}, acc ->
        if grid.mark, do: acc, else: acc + val
      end)

    sum * num
  end

  @doc """
  On the other hand, it might be wise to try a different strategy: let the giant squid win.

  You aren't sure how many bingo boards a giant squid could play at once,
  so rather than waste time counting its arms, the safe thing to do is to figure out
  which board will win last and choose that one.
  That way, no matter which boards it picks, it will win for sure.

  In the above example, the second board is the last to win, which happens after 13
  is eventually called and its middle column is completely marked.
  If you were to keep playing until this point, the second board would have a sum of
  unmarked numbers equal to 148 for a final score of 148 * 13 = 1924.

  Figure out which board will win last. Once it wins, what would its final score be?
  """
  @spec part_two(String.t()) :: integer
  def part_two(file_path) do
    {numbers, boards} = prepare_input(file_path)

    {_, [h | _], num} =
      Enum.reduce(numbers, {boards, [], nil}, fn num, {acc_b, acc_w, last_num} ->
        acc_b = Enum.map(acc_b, &mark_numbers(&1, num))

        case Enum.filter(acc_b, &is_winner?(&1)) do
          [] ->
            {acc_b, acc_w, last_num}

          winners ->
            acc_b = remove_winners(acc_b, winners)
            acc_w = winners ++ acc_w
            {acc_b, acc_w, num}
        end
      end)

    calculate_score(h, num)
  end

  defp remove_winners(acc, winners) do
    Enum.reject(acc, fn board ->
      Enum.member?(winners, board)
    end)
  end
end
