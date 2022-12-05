[stacks_initial, instructions] =
  File.read!("i")
  |> String.split("\n\n")

stacks_initial =
  stacks_initial
  |> String.split("\n")
  |> Stream.drop(-1)
  |> Stream.map(fn line ->
    line
    |> to_charlist()
    |> Stream.drop(1)
    |> Enum.take_every(4)
  end)
  |> Stream.zip_with(fn stack ->
    Enum.drop_while(stack, &(&1 == ?\s))
  end)
  |> Stream.with_index(1)
  |> Enum.into(%{}, fn {x, i} -> {i, x} end)

instructions
|> String.split("\n", trim: true)
|> Stream.map(fn line ->
  Regex.run(~r/move (\d+) from (\d) to (\d)/, line)
  |> Stream.drop(1)
  |> Enum.map(&String.to_integer/1)
end)
|> Enum.reduce(stacks_initial, fn [count, from, to], stacks ->
  moved = Enum.take(stacks[from], count)

  stacks
  |> Map.put(from, Enum.drop(stacks[from], count))
  |> Map.update!(to, &(moved ++ &1))
end)
|> Enum.map(fn {_, [x | _]} -> x end)
|> IO.puts()
