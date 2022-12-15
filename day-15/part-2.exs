defmodule M do
  def combinable(s1..e1 = r1, s2..e2 = r2) do
    not Range.disjoint?(r1, r2) or
      e1 + 1 === s2 or
      e2 + 1 === s1
  end

  def intersect(s1..e1, s2..e2) do
    start = max(s1, s2)
    ending = min(e1, e2)
    start..ending//1
  end

  def scanned_in_row(row, sensors) do
    Enum.filter(sensors, fn {{_x, y}, dist} ->
      abs(row - y) <= dist
    end)
    |> Enum.map(fn {{x, y}, dist} ->
      col1 = x + dist - abs(row - y)
      col2 = x - dist + abs(row - y)
      if col1 < col2, do: col1..col2, else: col2..col1
    end)
    |> Enum.sort_by(fn s.._ -> s end)
    |> Enum.map(fn r -> [r] end)
    |> Enum.reduce(fn [s..e], [last_s..last_e | acc_rest] = acc ->
      if M.combinable(s..e, last_s..last_e) do
        start = min(s, last_s)
        ending = max(e, last_e)
        [start..ending | acc_rest]
      else
        [s..e | acc]
      end
    end)
    |> Enum.reverse()
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

beacons = Enum.map(input, &elem(&1, 1)) |> Enum.uniq()

sensors =
  Enum.map(input, &elem(&1, 0))
  |> Enum.map(fn {x, y} ->
    d =
      beacons
      |> Enum.map(fn {bx, by} ->
        abs(bx - x) + abs(by - y)
      end)
      |> Enum.min()

    {{x, y}, d}
  end)

limit = if length(input) === 14, do: 20, else: 4_000_000
|> IO.inspect()

0..limit
|> Enum.find_value(fn row ->
  ranges =
    M.scanned_in_row(row, sensors)
    |> Enum.map(&M.intersect(&1, 0..limit))

  size =
    ranges
    |> Enum.map(&Range.size/1)
    |> Enum.sum()

  if size < Range.size(0..limit) do
    column =
      Stream.flat_map(ranges, & &1)
      |> Stream.with_index()
      |> Enum.find_value(fn {x, i} ->
        if x !== i, do: i
      end)

    {column, row}
  end
end)
|> then(fn {x, y} -> x * 4_000_000 + y end)
|> IO.puts()
