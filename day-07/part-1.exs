tree =
  File.stream!("i")
  |> Enum.map(&String.trim/1)
  |> Enum.reverse()
  |> Enum.chunk_while(
    [],
    fn line, acc ->
      start = String.slice(line, 0, 4)

      cond do
        start === "$ cd" -> {:cont, [line | acc], []}
        start === "$ ls" -> {:cont, acc}
        start === "dir " -> {:cont, acc}
        true -> {:cont, [line | acc]}
      end
    end,
    fn
      [] -> {:cont, []}
      acc -> {:cont, acc, []}
    end
  )
  |> Enum.reverse()
  |> Enum.reduce(%{stack: [], tree: %{}}, fn dir_content, %{stack: stack, tree: tree} ->
    [<<"$ cd ", dir_name::binary>> | items] = dir_content

    if dir_name === ".." do
      [_ | prev] = stack
      %{stack: prev, tree: tree}
    else
      dir_size =
        Enum.reduce(items, 0, fn item, acc ->
          [size, _name] = String.split(item, " ")
          acc + String.to_integer(size)
        end)

      new_stack = [dir_name | stack]
      new_tree = put_in(tree, Enum.reverse(new_stack), %{size: dir_size})

      %{stack: new_stack, tree: new_tree}
    end
  end)
  |> Map.get(:tree)

r = fn r, branch ->
  children =
    Map.keys(branch)
    |> Enum.reject(&(&1 === :size))
    |> Enum.map(fn child_key -> r.(r, branch[child_key]) end)

  children_size = Enum.map(children, &elem(&1, 0)) |> Enum.sum()
  total_size = children_size + Map.get(branch, :size, 0)

  final_sum =
    (Enum.map(children, &elem(&1, 1)) |> Enum.sum()) +
      if total_size < 100_000, do: total_size, else: 0

  {total_size, final_sum}
end

r.(r, tree)
|> elem(1)
|> IO.puts()
