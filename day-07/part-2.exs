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
  children_total =
    Map.keys(branch)
    |> Enum.reject(&(&1 === :size))
    |> Enum.map(fn child_key -> r.(r, branch[child_key]) end)
    |> Enum.sum()

  children_total + Map.get(branch, :size, 0)
end

minimum_to_delte = r.(r, tree) - 40_000_000

f = fn f, branch ->
  children =
    Map.keys(branch)
    |> Enum.reject(&(&1 === :size))
    |> Enum.map(fn child_key -> f.(f, branch[child_key]) end)

  children_total = Enum.map(children, &elem(&1, 0)) |> Enum.sum()
  this_total = children_total + Map.get(branch, :size, 0)

  min =
    [this_total | Enum.map(children, &elem(&1, 1))]
    |> Enum.filter(&(&1 >= minimum_to_delte))
    |> Enum.min(fn -> 0 end)

  {this_total, min}
end

f.(f, tree)
|> elem(1)
|> IO.puts()
