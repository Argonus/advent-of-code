defmodule AdventOfCode2020.Day11.Solution do
  @moduledoc """
  Your plane lands with plenty of time to spare. The final leg of your journey is a ferry that goes directly to the tropical island where you can finally start your vacation. As you reach the waiting area to board the ferry, you realize you're so early, nobody else has even arrived yet!

  By modeling the process people use to choose (or abandon) their seat in the waiting area, you're pretty sure you can predict the best place to sit. You make a quick map of the seat layout (your puzzle input).

  The seat layout fits neatly on a grid. Each position is either floor (.), an empty seat (L), or an occupied seat (#). For example, the initial seat layout might look like this:

  L.LL.LL.LL
  LLLLLLL.LL
  L.L.L..L..
  LLLL.LL.LL
  L.LL.LL.LL
  L.LLLLL.LL
  ..L.L.....
  LLLLLLLLLL
  L.LLLLLL.L
  L.LLLLL.LL

  Now, you just need to model the people who will be arriving shortly. Fortunately, people are entirely predictable and always follow a simple set of rules. All decisions are based on the number of occupied seats adjacent to a given seat (one of the eight positions immediately up, down, left, right, or diagonal from the seat). The following rules are applied to every seat simultaneously:

  - If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
  - If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
  - Otherwise, the seat's state does not change.

  Floor (.) never changes; seats don't move, and nobody sits on the floor.

  After one round of these rules, every seat in the example layout becomes occupied:

  #.##.##.##
  #######.##
  #.#.#..#..
  ####.##.##
  #.##.##.##
  #.#####.##
  ..#.#.....
  ##########
  #.######.#
  #.#####.##

  After a second round, the seats with four or more occupied adjacent seats become empty again:

  #.LL.L#.##
  #LLLLLL.L#
  L.L.L..L..
  #LLL.LL.L#
  #.LL.LL.LL
  #.LLLL#.##
  ..L.L.....
  #LLLLLLLL#
  #.LLLLLL.L
  #.#LLLL.##

  This process continues for three more rounds:

  At this point, something interesting happens: the chaos stabilizes and further applications of these rules cause no seats to change state! Once people stop moving around, you count 37 occupied seats.

  Simulate your seating area by applying the seating rules repeatedly until no seats change state. How many seats end up occupied?
  """

  require IEx

  @type file_path :: String.t()
  @free_seat "L"
  @occupied_seat "#"
  @floor "."

  @movements [
    {-1, 0},
    {0, -1},
    {-1, -1},
    {1, 0},
    {0, 1},
    {1, 1},
    {1, -1},
    {-1, 1}
  ]

  @part_one_max_neighbours 4

  @spec part_one(file_path) :: integer
  def part_one(file_path) do
    file_path
    |> parse_file_to_seats_map()
    |> play_round_one([])
    |> count_occupations
  end

  defp parse_file_to_seats_map(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&build_seats_line/1)
    |> Stream.with_index()
    |> Enum.reduce(%{}, &build_seats_map/2)
  end

  defp build_seats_line(line), do: line |> String.trim() |> String.graphemes()

  defp build_seats_map({seats, line_index}, acc) do
    seats
    |> Enum.with_index()
    |> Enum.reduce(acc, fn {seat, seat_index}, acc2 ->
      Map.put(acc2, {line_index, seat_index}, seat)
    end)
  end

  defp play_round_one(seats_map, seats_map), do: seats_map

  defp play_round_one(seats_map, _prev_seats_map) do
    new_seats_map =
      Enum.into(seats_map, %{}, fn {pos, seat} ->
        new_seat = new_seat_occupation_one(pos, seat, seats_map)
        {pos, new_seat}
      end)

    play_round_one(new_seats_map, seats_map)
  end

  defp new_seat_occupation_one(_, @floor, _), do: @floor

  defp new_seat_occupation_one(pos, seat, seats_map) do
    case seat do
      @free_seat ->
        occupations = new_seat_occupation_one(pos, seats_map)
        if occupations == 0, do: @occupied_seat, else: seat

      @occupied_seat ->
        occupations = new_seat_occupation_one(pos, seats_map)
        if occupations >= @part_one_max_neighbours, do: @free_seat, else: seat

      value ->
        value
    end
  end

  defp new_seat_occupation_one(pos, seats_map) do
    @movements
    |> Enum.map(&find_neighbour_one(&1, pos, seats_map))
    |> Enum.count(&(&1 == @occupied_seat))
  end

  defp find_neighbour_one({line_add, seat_add}, {line_index, seat_index}, seats_map) do
    lookup_line = line_index + line_add
    lookup_seat = seat_index + seat_add
    lookup_pos = {lookup_line, lookup_seat}

    case Map.get(seats_map, lookup_pos, :out_of_bound) do
      :out_of_bound -> nil
      value -> value
    end
  end

  defp count_occupations(seats_map) do
    seats_map
    |> Map.values()
    |> Enum.count(&(&1 == @occupied_seat))
  end

  @doc """
  As soon as people start to arrive, you realize your mistake. People don't just care about adjacent seats - they care about the first seat they can see in each of those eight directions!

  Now, instead of considering just the eight immediately adjacent seats, consider the first seat in each of those eight directions. For example, the empty seat below would see eight occupied seats:

  .......#.
  ...#.....
  .#.......
  .........
  ..#L....#
  ....#....
  .........
  #........
  ...#.....

  The leftmost empty seat below would only see one empty seat, but cannot see any of the occupied ones:

  The empty seat below would see no occupied seats:

  Also, people seem to be more tolerant than you expected: it now takes five or more visible occupied seats for an occupied seat to become empty (rather than four or more from the previous rules). The other rules still apply: empty seats that see no occupied seats become occupied, seats matching no rule don't change, and floor never changes

  Given the same starting layout as above, these new rules cause the seating area to shift around as follows

  L.LL.LL.LL
  LLLLLLL.LL
  L.L.L..L..
  LLLL.LL.LL
  L.LL.LL.LL
  L.LLLLL.LL
  ..L.L.....
  LLLLLLLLLL
  L.LLLLLL.L
  L.LLLLL.LL

  #.##.##.##
  #######.##
  #.#.#..#..
  ####.##.##
  #.##.##.##
  #.#####.##
  ..#.#.....
  ##########
  #.######.#
  #.#####.##

  ...

  Again, at this point, people stop shifting around and the seating area reaches equilibrium. Once this occurs, you count 26 occupied seats.

  Given the new visibility method and the rule change for occupied seats becoming empty, once equilibrium is reached, how many seats end up occupied?
  """

  # {line_index, seat_index}
  @part_two_max_neighbours 5

  @spec part_two(file_path) :: integer
  def part_two(file_path) do
    file_path
    |> parse_file_to_seats_map()
    |> play_round_two(%{})
    |> count_occupations()
  end

  defp play_round_two(seats_map, seats_map), do: seats_map

  defp play_round_two(seats_map, _prev_seats_map) do
    new_seats_map =
      Enum.into(seats_map, %{}, fn {pos, seat} ->
        new_seat = new_seat_occupation_two(pos, seat, seats_map)
        {pos, new_seat}
      end)

    play_round_two(new_seats_map, seats_map)
  end

  defp new_seat_occupation_two(_, @floor, _), do: @floor

  defp new_seat_occupation_two(pos, seat, seats_map) do
    case seat do
      @free_seat ->
        occupations = count_occupations_two(pos, seats_map)
        if occupations == 0, do: @occupied_seat, else: seat

      @occupied_seat ->
        occupations = count_occupations_two(pos, seats_map)
        if occupations >= @part_two_max_neighbours, do: @free_seat, else: seat

      value ->
        value
    end
  end

  defp count_occupations_two(pos, seats_map) do
    @movements
    |> Enum.map(&find_neighbour_two(&1, pos, seats_map))
    |> Enum.count(&(&1 == @occupied_seat))
  end

  defp find_neighbour_two(movement = {line_add, seat_add}, {line_index, seat_index}, seats_map) do
    lookup_line = line_index + line_add
    lookup_seat = seat_index + seat_add
    lookup_pos = {lookup_line, lookup_seat}

    case Map.get(seats_map, lookup_pos, :out_of_bound) do
      :out_of_bound -> nil
      @floor -> find_neighbour_two(movement, lookup_pos, seats_map)
      value -> value
    end
  end
end
