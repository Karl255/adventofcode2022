defmodule RangeHelpers do
  def combinable(s1..e1 = r1, s2..e2 = r2) do
    not Range.disjoint?(r1, r2) or
      e1 + 1 === s2 or
      e2 + 1 === s1
  end
end

input =
  File.stream!("i")
  |> Enum.map(&String.trim/1)
  |> Enum.map(fn line ->
    [sx, sy, bx, by] =
      Regex.run(
        ~r/Sensor at x=([-\d]+), y=([-\d]+): closest beacon is at x=([-\d]+), y=([-\d]+)/,
        line
      )
      |> Enum.drop(1)
      |> Enum.map(&String.to_integer/1)

    {{sx, sy}, {bx, by}}
  end)

sensors = Enum.map(input, &elem(&1, 0))
beacons = Enum.map(input, &elem(&1, 1)) |> Enum.uniq()
row = if length(sensors) === 14, do: 10, else: 2_000_000

ranges =
  sensors
  |> Enum.map(fn {x, y} ->
    dist =
      beacons
      |> Enum.map(fn {bx, by} ->
        abs(bx - x) + abs(by - y)
      end)
      |> Enum.min()

    col1 = x + dist - abs(row - y)
    col2 = x - dist + abs(row - y)

    if col1 < col2, do: col1..col2, else: col2..col1
  end)
  |> Enum.sort_by(fn s.._ -> s end)
  |> Enum.map(fn r -> [r] end)
  |> Enum.reduce(fn [s..e], [last_s..last_e | acc_rest] = acc ->
    if RangeHelpers.combinable(s..e, last_s..last_e) do
      bigger = max(e, last_e)
      smaller = min(s, last_s)
      [smaller..bigger | acc_rest]
    else
      [s..e | acc]
    end
  end)
  |> Enum.reverse()

not_a_beacon =
  Enum.map(ranges, &Range.size(&1))
  |> Enum.sum()

beacons_in_row = Enum.count(beacons, fn {_x, y} -> y === row end)

IO.puts(not_a_beacon - beacons_in_row)
