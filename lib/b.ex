defmodule B do
  use GenStage

  def start_link(name) do
    IO.inspect name
    GenStage.start_link(B, 1, name: name)
  end

  def init(number) do
    {:producer_consumer, number, subscribe_to: [{A, max_demand: 1}], buffer_size: 100}
  end

  def handle_events(events, _from, number) do
    IO.inspect(events)
    events = Enum.map(events, & &1 * number)
    Process.sleep(5000)
    {:noreply, events, number}
  end
end