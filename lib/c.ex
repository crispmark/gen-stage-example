defmodule C do
  use GenStage

  def start_link(producers) do
    GenStage.start_link(C, producers)
  end

  def init(producers) do
    producer_options = producers
    |> Enum.map(&({&1, max_demand: 1}))
    {:consumer, :the_state_does_not_matter, subscribe_to: producer_options}
  end

  def handle_events(events, _from, state) do
    events
    |> Enum.map(fn event ->
      Process.sleep(500)
      IO.inspect event
      IO.inspect self()
    end)

    # We are a consumer, so we would never emit items.
    {:noreply, [], state}
  end
end