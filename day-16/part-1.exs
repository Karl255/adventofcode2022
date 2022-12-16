# NOTE: this is unusably slow

defmodule M do
  def traverse(current, tunnels, valve_rates, open_rates \\ [], released \\ 0, minute \\ 1)

  def traverse(current, tunnels, valve_rates, open_rates, released, minute) do
    released = released + Enum.sum(open_rates)

    if minute < 30 do
      open_rates =
        if Map.has_key?(valve_rates, current) and valve_rates[current] > 0 do
          [valve_rates[current] | open_rates]
        else
          open_rates
        end

      valve_rates = Map.delete(valve_rates, current)

      if map_size(valve_rates) > 0 do
        Enum.map(tunnels[current], fn destination ->
          traverse(destination, tunnels, valve_rates, open_rates, released, minute + 1)
        end)
        |> Enum.max(fn -> 0 end)
      else
        released + (30 - minute) * Enum.sum(open_rates)
      end
    else
      released
    end
  end
end

line_regex = ~r/Valve ([A-Z]{2}) has flow rate=(\d+); tunnels? leads? to valves? ([A-Z, ]+)/

{valve_rates, tunnels} =
  File.stream!("i")
  |> Enum.map(fn line ->
    [valve, rate, tunnels_to] =
      Regex.run(line_regex, line)
      |> Enum.drop(1)

    rate = String.to_integer(rate)
    tunnels_to = String.split(tunnels_to, ", ")

    {valve, rate, tunnels_to}
  end)
  |> Enum.reduce({%{}, %{}}, fn {valve, rate, tunnels_to}, {valve_rates, tunnels} ->
    {
      Map.put(valve_rates, valve, rate),
      Map.put(tunnels, valve, tunnels_to)
    }
  end)

# I have no clue how to approach this

zeros =
  Enum.filter(valve_rates, fn {k, v} -> k !== "AA" and v === 0 end)
  |> Enum.map(fn {k, _v} -> k end)

tunnels =
  Enum.map(tunnels, fn {valve, to} ->
    to = Enum.reject(to, fn id -> id in zeros end)

    {valve, to}
  end)
  |> IO.inspect()
  |> Enum.into(%{})

# valve_rates = Map.reject(valve_rates, fn {_, v} -> v === 0 end)

M.traverse("AA", tunnels, valve_rates)
|> IO.inspect()
