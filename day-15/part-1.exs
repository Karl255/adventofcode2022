defmodule M do
  def check(sensor, beacons, checked \\ MapSet.new(), i \\ 0) do
    diamond = gen_diamond(sensor, i)
    new_checked = MapSet.union(diamond, checked)

    if MapSet.disjoint?(beacons, diamond) do
      check(sensor, beacons, new_checked, i + 1)
    else
      new_checked
    end
  end

  def gen_diamond(origin, 0), do: MapSet.new([origin])

  def gen_diamond({x, y}, offset) do
    Enum.flat_map(1..offset, fn d1 ->
      d2 = offset - d1

      [
        {x + d1, y + d2},
        {x - d2, y + d1},
        {x - d1, y - d2},
        {x + d2, y - d1}
      ]
    end)
    |> MapSet.new()
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

beacons =
  Enum.map(input, &elem(&1, 1))
  |> MapSet.new()

row = if length(sensors) === 14, do: 10, else: 2_000_000

Enum.reduce(sensors, MapSet.new(), fn sensor, checked ->
  MapSet.union(M.check(sensor, beacons), checked)
end)
|> MapSet.difference(beacons)
|> Enum.filter(fn {_x, y} -> y === row end)
|> Enum.count()
|> IO.puts()
