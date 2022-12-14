defmodule M do
  def simulate_grain(walls, max_y, {x, y} \\ {500, 0}) do
    cond do
      y === max_y -> nil
      not MapSet.member?(walls, {x, y + 1}) -> simulate_grain(walls, max_y, {x, y + 1})
      not MapSet.member?(walls, {x - 1, y + 1}) -> simulate_grain(walls, max_y, {x - 1, y + 1})
      not MapSet.member?(walls, {x + 1, y + 1}) -> simulate_grain(walls, max_y, {x + 1, y + 1})
      true -> {x, y}
    end
  end

  def simulate_sand(walls, max_y, n \\ 0) do
    case simulate_grain(walls, max_y) do
      {_x, _y} = grain -> simulate_sand(MapSet.put(walls, grain), max_y, n + 1)
      nil -> n
    end
  end
end

walls =
  File.stream!("i")
  |> Enum.map(&String.trim/1)
  |> Enum.map(fn polyline ->
    [start | points] =
      String.split(polyline, " -> ")
      |> Enum.map(fn point ->
        String.split(point, ",")
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()
      end)

    Enum.reduce(points, {start, MapSet.new()}, fn {x, y} = point, {{from_x, from_y}, acc} ->
      all_dots =
        if from_x === x do
          Enum.map(from_y..y, &{x, &1})
        else
          Enum.map(from_x..x, &{&1, y})
        end

      {point, MapSet.union(acc, MapSet.new(all_dots))}
    end)
    |> elem(1)
  end)
  |> Enum.reduce(&MapSet.union/2)

{_, max_y} = Enum.max_by(walls, fn {_x, y} -> y end)

M.simulate_sand(walls, max_y)
|> IO.puts()
