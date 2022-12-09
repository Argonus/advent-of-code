defmodule Day07 do
  @moduledoc """
  Documentation for `Day07`.
  """

  @limit_one 100_000

  @spec part_one(String.t()) :: integer
  def part_one(file_path) do
    graph = init_graph()

    file_path
    |> parse_file()
    |> Enum.reduce({"/", graph}, &graph_reducer/2)
    |> get_dir_sizes()
    |> Enum.reduce(0, &sum_sizes/2)
  end

  defp sum_sizes(size, acc) when size <= @limit_one, do: acc + size
  defp sum_sizes(size, acc), do: acc

  @disc_size 70_000_000
  @space_required 30_000_000

  @spec part_two(String.t()) :: integer
  def part_two(file_path) do
    graph = init_graph()

    sizes =
      file_path
      |> parse_file()
      |> Enum.reduce({"/", graph}, &graph_reducer/2)
      |> get_dir_sizes()

    root_size = Enum.max(sizes)

    sizes
    |> Enum.filter(&space_required?(&1, root_size))
    |> Enum.min()
  end

  defp space_required?(dir_size, root_size) do
    dir_size >= @space_required - (@disc_size - root_size)
  end

  ### Helpers

  @ls_operator "$ ls"
  @root_operator "$ cd /"

  def parse_file(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.reject(&(&1 == @ls_operator || &1 == @root_operator))
  end

  ### Build Graph

  defp init_graph do
    graph = :digraph.new([:acyclic])
    :digraph.add_vertex(graph, "/", 0)
    graph
  end

  @non_digits_regexp ~r/[^\d]/

  defp graph_reducer(line, {current_path, graph}) do
    case line do
      <<"$ cd ..">> ->
        parent = get_vertex_parent(graph, current_path)
        {parent, graph}

      <<"$ cd ", new_dir::binary>> ->
        new_path = new_dir(current_path, new_dir)
        {new_path, graph}

      <<"dir ", new_dir::binary>> ->
        new_path = new_dir(current_path, new_dir)
        add_graph_vertex(graph, current_path, new_path)
        {current_path, graph}

      file_info ->
        size = file_info |> String.split(" ") |> hd() |> String.to_integer()
        update_graph_vertex(graph, current_path, size)
        {current_path, graph}
    end
  end

  defp new_dir(parent, dir), do: parent <> dir

  def get_vertex_parent(graph, current_path) do
    graph |> :digraph.in_neighbours(current_path) |> List.first()
  end

  defp add_graph_vertex(graph, parent, new_path) do
    :digraph.add_vertex(graph, new_path, 0)
    :digraph.add_edge(graph, parent, new_path)
  end

  defp update_graph_vertex(graph, node, size) do
    {_, prev_size} = :digraph.vertex(graph, node)
    :digraph.add_vertex(graph, node, size + prev_size)

    case get_vertex_parent(graph, node) do
      nil -> :ok
      parent -> update_graph_vertex(graph, parent, size)
    end
  end

  defp get_dir_sizes({_, graph}) do
    graph
    |> :digraph.vertices()
    |> Enum.map(fn dir ->
      {_, size} = :digraph.vertex(graph, dir)
      size
    end)
  end
end
