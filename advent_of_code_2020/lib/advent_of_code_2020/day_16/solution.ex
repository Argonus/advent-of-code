defmodule AdventOfCode2020.Day16.Solution do
  @moduledoc """
  As you're walking to yet another connecting flight, you realize that one of the legs of your re-routed trip coming up is on a high-speed train. However, the train ticket you were given is in a language you don't understand. You should probably figure out what it says before you get to the train station after the next flight.

  Unfortunately, you can't actually read the words on the ticket. You can, however, read the numbers, and so you figure out the fields these tickets must have and the valid ranges for values in those fields.

  You collect the rules for ticket fields, the numbers on your ticket, and the numbers on other nearby tickets for the same train service (via the airport security cameras) together into a single document you can reference (your puzzle input).

  The rules for ticket fields specify a list of fields that exist somewhere on the ticket and the valid ranges of values for each field. For example, a rule like class: 1-3 or 5-7 means that one of the fields in every ticket is named class and can be any value in the ranges 1-3 or 5-7 (inclusive, such that 3 and 5 are both valid in this field, but 4 is not).

  Each ticket is represented by a single line of comma-separated values. The values are the numbers on the ticket in the order they appear; every ticket has the same format. For example, consider this ticket:

  .--------------------------------------------------------.
  | ????: 101    ?????: 102   ??????????: 103     ???: 104 |
  |                                                        |
  | ??: 301  ??: 302             ???????: 303      ??????? |
  | ??: 401  ??: 402           ???? ????: 403    ????????? |
  '--------------------------------------------------------'

  Here, ? represents text in a language you don't understand. This ticket might be represented as 101,102,103,104,301,302,303,401,402,403; of course, the actual train tickets you're looking at are much more complicated. In any case, you've extracted just the numbers in such a way that the first number is always the same specific field, the second number is always a different specific field, and so on - you just don't know what each position actually means!

  Start by determining which tickets are completely invalid; these are tickets that contain values which aren't valid for any field. Ignore your ticket for now.

  For example, suppose you have the following notes:

  class: 1-3 or 5-7
  row: 6-11 or 33-44
  seat: 13-40 or 45-50

  your ticket:
  7,1,14

  nearby tickets:
  7,3,47
  40,4,50
  55,2,20
  38,6,12
  """

  @type file_path :: String.t()

  @doc """
  It doesn't matter which position corresponds to which field; you can identify invalid nearby tickets by considering only whether tickets contain values that are not valid for any field. In this example, the values on the first nearby ticket are all valid for at least one field. This is not true of the other three nearby tickets: the values 4, 55, and 12 are are not valid for any field. Adding together all of the invalid values produces your ticket scanning error rate: 4 + 55 + 12 = 71.

  Consider the validity of the nearby tickets you scanned. What is your ticket scanning error rate?
  """
  @spec part_one(file_path) :: integer
  def part_one(file_path) do
    file_path
    |> parse_file()
    |> reject_valid_values()
    |> Enum.sum()
  end

  defp reject_valid_values(%{notes: notes, nearby_tickets: tickets}) do
    ticket_valid_sets = notes_to_range_mapset(notes)

    Enum.flat_map(tickets, fn ticket ->
      Enum.filter(ticket, &(!MapSet.member?(ticket_valid_sets, &1)))
    end)
  end

  @doc """
  Now that you've identified which tickets contain invalid values, discard those tickets entirely. Use the remaining valid tickets to determine which field is which.

  Using the valid ranges for each field, determine what order the fields appear on the tickets. The order is consistent between all tickets: if seat is the third field, it is the third field on every ticket, including your ticket.

  For example, suppose you have the following notes:

  class: 0-1 or 4-19
  row: 0-5 or 8-19
  seat: 0-13 or 16-19

  your ticket:
  11,12,13

  nearby tickets:
  3,9,18
  15,1,5
  5,14,9

  Based on the nearby tickets in the above example, the first position must be row, the second position must be class, and the third position must be seat; you can conclude that in your ticket, class is 12, row is 11, and seat is 13.

  Once you work out which field is which, look for the six fields on your ticket that start with the word departure. What do you get if you multiply those six values together?
  """

  @search_fields [
    "departure location",
    "departure station",
    "departure platform",
    "departure track",
    "departure date",
    "departure time"
  ]

  @spec part_two(file_path) :: integer
  def part_two(file_path) do
    file_path
    |> parse_file()
    |> reject_invalid_values()
    |> decipher_fields()
    |> calculate_result()
  end

  defp reject_invalid_values(data = %{notes: notes, nearby_tickets: tickets}) do
    valid_values = notes_to_range_mapset(notes)
    nearby_tickets = Enum.filter(tickets, &is_ticket_valid?(&1, valid_values))

    %{data | nearby_tickets: nearby_tickets}
  end

  def is_ticket_valid?(ticket, valid_values) do
    MapSet.subset?(MapSet.new(ticket), valid_values)
  end

  defp decipher_fields(%{my_ticket: my_ticket, notes: notes, nearby_tickets: valid_nearby_tickets}) do
    field_sets = notes_to_range_mapsets(notes)
    value_sets = ticket_to_value_mapsets(valid_nearby_tickets, 0, [])

    fields = decipher_field_by_field(value_sets, field_sets, %{})

    %{fields: fields, my_ticket: my_ticket}
  end

  defp ticket_to_value_mapsets([], _, acc), do: acc

  defp ticket_to_value_mapsets(tickets, idx, acc) do
    {values, new_tickets} =
      tickets
      |> Enum.map(fn [head | tail] -> {head, tail} end)
      |> Enum.reduce({[], []}, fn {head, tail}, {head_acc, tail_acc} ->
        new_head = [head | head_acc]
        new_tail = if tail == [], do: tail_acc, else: [tail | tail_acc]
        {new_head, new_tail}
      end)

    ticket_to_value_mapsets(new_tickets, idx + 1, [{MapSet.new(values), idx} | acc])
  end

  def decipher_field_by_field([], _, acc), do: acc

  def decipher_field_by_field([values = {value_set, pos} | unknown], field_sets, acc) do
    case field_candidates(value_set, field_sets) do
      [field_name] ->
        new_field_sets = Enum.reject(field_sets, &(elem(&1, 0) == field_name))
        decipher_field_by_field(unknown, new_field_sets, Map.put(acc, field_name, pos))

      _ ->
        decipher_field_by_field(unknown ++ [values], field_sets, acc)
    end
  end

  defp field_candidates(values, field_sets) do
    field_sets
    |> Enum.filter(fn {_field, valid_values} ->
      MapSet.subset?(values, valid_values)
    end)
    |> Enum.map(&elem(&1, 0))
  end

  defp calculate_result(%{fields: fields, my_ticket: my_ticket}) do
    @search_fields
    |> Enum.map(&Map.fetch!(fields, &1))
    |> Enum.map(&Enum.at(my_ticket, &1, 0))
    |> Enum.reduce(&Kernel.*/2)
  end

  ####################
  # Common functions #
  ####################

  @my_ticket_header "your ticket:"
  @nearby_tickets_header "nearby tickets:"

  defp parse_file(file_path) do
    file_path
    |> File.stream!()
    |> Stream.chunk_while([], &chunk_fun/2, &after_fun/1)
    |> Enum.reduce(%{}, &parse_input/2)
  end

  defp chunk_fun("\n", acc), do: {:cont, Enum.reverse(acc), []}
  defp chunk_fun(el, acc), do: {:cont, [String.trim(el) | acc]}

  defp after_fun([]), do: {:cont, []}
  defp after_fun(acc), do: {:cont, Enum.reverse(acc), []}

  defp parse_input(chunk = [head | tail], acc) do
    case String.trim(head) do
      @my_ticket_header ->
        ticket = parse_tickets(tail)
        Map.put(acc, :my_ticket, ticket)

      @nearby_tickets_header ->
        tickets = parse_tickets(tail)
        Map.put(acc, :nearby_tickets, tickets)

      _ ->
        notes = parse_notes(chunk)
        Map.put(acc, :notes, notes)
    end
  end

  defp parse_tickets([ticket]), do: parse_ticket(ticket)
  defp parse_tickets(tickets) when is_list(tickets), do: Enum.map(tickets, &parse_ticket/1)

  defp parse_ticket(ticket) do
    ticket
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer(&1))
  end

  defp parse_notes(notes), do: Enum.map(notes, &parse_note/1)

  defp parse_note(note) do
    [note_attr, range_strs] = String.split(note, ": ")

    ranges =
      range_strs
      |> String.split(" or ", trim: true)
      |> Enum.map(fn range_str ->
        range_str |> String.split("-") |> Enum.map(&String.to_integer/1)
      end)

    {note_attr, ranges}
  end

  defp notes_to_range_mapset(notes) do
    Enum.reduce(notes, MapSet.new(), fn {_note, [range_1, range_2]}, acc ->
      range_1_values = range_to_list(range_1)
      range_2_values = range_to_list(range_2)
      MapSet.union(acc, MapSet.new(range_2_values ++ range_1_values))
    end)
  end

  defp notes_to_range_mapsets(notes) do
    Enum.reduce(notes, %{}, fn {note, [range_1, range_2]}, acc ->
      range_1_values = range_to_list(range_1)
      range_2_values = range_to_list(range_2)
      values = MapSet.new(range_2_values ++ range_1_values)

      Map.put(acc, note, values)
    end)
  end

  defp range_to_list([v1, v2]), do: Enum.to_list(v1..v2)
end
