defmodule H do
  def to_coords(index, width) do
    {rem(index, width + 1), div(index, width + 1)}
  end

  def to_index({x, y}, width) do
    y * (width + 1) + x
  end

  def map_at({map, _width, _height}, index) do
    <<c>> = String.at(map, index)
    c
  end

  def find_end(nodes, {_, width, height} = map, visited, steps \\ 0) do
    if Enum.any?(nodes, fn coords -> map_at(map, to_index(coords, width)) === ?a end) do
      steps
    else
      visited = MapSet.union(visited, MapSet.new(nodes))

      next_nodes =
        Enum.flat_map(nodes, fn {x, y} ->
          at_height = map_at(map, to_index({x, y}, width))
          
          [
            if x + 1 < width do
              next_coords = {x + 1, y}
              next_height = map_at(map, to_index(next_coords, width))

              if at_height - 1 <= next_height and not MapSet.member?(visited, next_coords) do
                next_coords
              end
            end,
            if x - 1 >= 0 do
              next_coords = {x - 1, y}
              next_height = map_at(map, to_index(next_coords, width))

              if at_height - 1 <= next_height and not MapSet.member?(visited, next_coords) do
                next_coords
              end
            end,
            if y + 1 < height do
              next_coords = {x, y + 1}
              next_height = map_at(map, to_index(next_coords, width))

              if at_height - 1 <= next_height and not MapSet.member?(visited, next_coords) do
                next_coords
              end
            end,
            if y - 1 >= 0 do
              next_coords = {x, y - 1}
              next_height = map_at(map, to_index(next_coords, width))

              if at_height - 1 <= next_height and not MapSet.member?(visited, next_coords) do
                next_coords
              end
            end
          ]
        end)
        |> MapSet.new()
        |> MapSet.to_list()
        |> Enum.filter(& &1)

      find_end(next_nodes, map, visited, steps + 1)
    end
  end
end

heightmap = File.read!("i")

heightmap_list = to_charlist(heightmap)

map_width = Enum.find_index(heightmap_list, &(&1 == ?\n))
map_height = Enum.count(heightmap_list, &(&1 == ?\n))
ending = Enum.find_index(heightmap_list, &(&1 === ?E)) |> H.to_coords(map_width)

heightmap =
  heightmap
  |> String.replace("S", "a")
  |> String.replace("E", "z")

visited = MapSet.new()

H.find_end([ending], {heightmap, map_width, map_height}, visited)
|> IO.inspect()
