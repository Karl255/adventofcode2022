File.read!("i")
|> String.split("\n", trim: true)
|> Enum.map(fn line ->
  String.split(line, ",")
  |> Enum.map(fn elf ->
    String.split(elf, "-")
    |> Enum.map(&String.to_integer/1)
    |> then(fn [s, e] -> MapSet.new(s..e) end)
  end)
end)
|> Enum.count(fn [elf1, elf2] ->
  MapSet.subset?(elf1, elf2) or MapSet.subset?(elf2, elf1)
end)
|> IO.puts()
