defmodule AdventOfCode2020.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: AdventOfCode2020.TaskSupervisor}
    ]

    opts = [strategy: :one_for_one, name: AdventOfCode2020.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
