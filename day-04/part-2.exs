File.read!("i")
|> String.split("\n", trim: true)
|> Enum.map(fn l ->
  String.split(l, ",")
  |> Enum.map(fn r ->
    String.split(r, "-")
    |> Enum.map(&String.to_integer/1)
  end)
  |> Enum.map(fn [s, e] -> s..e end)
end)
|> Enum.count(fn [r1, r2] ->
  not Range.disjoint?(r1, r2)
end)
|> IO.puts()
