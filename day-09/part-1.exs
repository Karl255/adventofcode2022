File.stream!("i")
|> Enum.flat_map(fn <<dir, ?\s, n::binary>> ->
  n = String.trim(n) |> String.to_integer()

  dir =
    case dir do
      ?R -> :right
      ?L -> :left
      ?U -> :up
      ?D -> :down
      _ -> throw(dir)
    end

  List.duplicate(dir, n)
end)
|> Enum.reduce(
  {{0, 0}, {0, 0}, MapSet.new([{0, 0}])},
  fn dir, {{hx, hy}, {tx, ty} = tail, visited} ->
    {new_hx, new_hy} =
      case dir do
        :right -> {hx + 1, hy}
        :left  -> {hx - 1, hy}
        :up    -> {hx, hy + 1}
        :down  -> {hx, hy - 1}
      end

    new_tail =
      case dir do
        :right -> if new_hx > tx + 1, do: {tx + 1, new_hy}, else: tail
        :left  -> if new_hx < tx - 1, do: {tx - 1, new_hy}, else: tail
        :up    -> if new_hy > ty + 1, do: {new_hx, ty + 1}, else: tail
        :down  -> if new_hy < ty - 1, do: {new_hx, ty - 1}, else: tail
      end

    {{new_hx, new_hy}, new_tail, MapSet.put(visited, new_tail)}
  end
)
|> then(fn {_head, _tail, visited} ->
  MapSet.size(visited)
end)
|> IO.puts()
