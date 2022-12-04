File.read!("i")
|> String.split("\n", trim: true)
|> Enum.map(fn line ->
  String.split(line, ",")
  |> Enum.map(fn elf ->
    [s, e] =
      String.split(elf, "-")
      |> Enum.map(&String.to_integer/1)

    s..e
  end)
end)
|> Enum.count(fn [elf1, elf2] ->
  not Range.disjoint?(elf1, elf2)
end)
|> IO.puts()
