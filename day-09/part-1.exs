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
  fn dir, {{head_x, head_y}, {tail_x, tail_y}, visited} ->
    {new_head, new_tail} =
      case dir do
        :right ->
          if tail_x < head_x do
            {{head_x + 1, head_y}, {tail_x + 1, head_y}}
          else
            {{head_x + 1, head_y}, {tail_x, tail_y}}
          end

        :left ->
          if head_x < tail_x do
            {{head_x - 1, head_y}, {tail_x - 1, head_y}}
          else
            {{head_x - 1, head_y}, {tail_x, tail_y}}
          end

        :up ->
          if tail_y < head_y do
            {{head_x, head_y + 1}, {head_x, tail_y + 1}}
          else
            {{head_x, head_y + 1}, {tail_x, tail_y}}
          end

        :down ->
          if head_y < tail_y do
            {{head_x, head_y - 1}, {head_x, tail_y - 1}}
          else
            {{head_x, head_y - 1}, {tail_x, tail_y}}
          end
      end

    {new_head, new_tail, MapSet.put(visited, new_tail)}
  end
)
|> then(fn {_head, _tail, visited} ->
  MapSet.size(visited)
end)
|> IO.puts()
