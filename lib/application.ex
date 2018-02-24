defmodule GenStage.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    a = worker(A, [0])
    producer_consumer_atoms = Enum.to_list(1..50)
    |> Enum.map(&("B#{&1}"))
    |> Enum.map(&String.to_atom/1)

    producer_consumers = producer_consumer_atoms
    |> Enum.map(fn atom -> worker(B, [atom], id: atom) end)
    c = worker(C, [producer_consumer_atoms])

    children = [a] ++ producer_consumers ++ [c]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :rest_for_one, name: GenStageExample.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
