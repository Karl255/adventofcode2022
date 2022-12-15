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
beacons = Enum.map(input, &elem(&1, 1))
row = if length(sensors) === 14, do: 10, else: 2_000_000

beacons_in_row =
  Enum.filter(beacons, fn {_x, y} -> y === row end)
  |> Enum.map(&elem(&1, 0))
  |> MapSet.new()

Enum.map(sensors, fn {x, y} ->
  d =
    Enum.map(beacons, fn {bx, by} ->
      abs(bx - x) + abs(by - y)
    end)
    |> Enum.min()

  {{x, y}, d}
end)
|> Enum.map(fn {{x, y}, dist} ->
  col1 = x + dist - abs(row - y)
  col2 = x - dist + abs(row - y)
  # this could be further optimized by using a list of ranges, but this works well-enough for now
  # if col1 < col2, do: col1..col2, else: col2..col1
  MapSet.new(col1..col2)
end)
|> Enum.reduce(&MapSet.union/2)
|> MapSet.difference(beacons_in_row)
|> MapSet.size()
|> IO.inspect(syntax_colors: IO.ANSI.syntax_colors())
