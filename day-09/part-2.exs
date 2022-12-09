defmodule H do
  def clamp(x, min \\ -1, max \\ 1) do
    cond do
      x < min -> min
      x > max -> max
      true -> x
    end
  end
end

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
  {List.duplicate({0, 0}, 10), MapSet.new([{0, 0}])},
  fn dir, {[{hx, hy} | rope], visited} ->
    new_head =
      case dir do
        :right -> {hx + 1, hy}
        :left  -> {hx - 1, hy}
        :up    -> {hx, hy + 1}
        :down  -> {hx, hy - 1}
      end

    new_rope =
      Enum.reduce(
        rope,
        [new_head],
        fn {tx, ty} = tail, [{hx, hy} | _] = acc ->
          new_tail =
            cond do
              hx - tx >= 2 -> {tx + 1, ty + H.clamp(hy - ty)}
              tx - hx >= 2 -> {tx - 1, ty + H.clamp(hy - ty)}
              hy - ty >= 2 -> {tx + H.clamp(hx - tx), ty + 1}
              ty - hy >= 2 -> {tx + H.clamp(hx - tx), ty - 1}
              true -> tail 
            end
          [new_tail | acc]
        end
      )
      |> Enum.reverse()

    {new_rope, MapSet.put(visited, List.last(new_rope))}
  end
)
|> then(fn {_rope, visited} ->
  MapSet.size(visited)
end)
|> IO.puts()
