defmodule A do
  use GenStage

  def start_link(number) do
    GenStage.start_link(A, number, name: A)
  end

  def init(counter) do
    {:producer, counter, buffer_size: 3}
  end

  def handle_demand(demand, counter) when demand > 0 do
    IO.inspect demand
    events = Enum.to_list(counter..counter+demand-1)
    {:noreply, events, counter + demand}
  end
end