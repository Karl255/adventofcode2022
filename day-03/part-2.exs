File.read!("i")
|> String.split("\n", trim: true)
|> Enum.map(&MapSet.new(to_charlist(&1)))
|> Enum.chunk_every(3)
|> Enum.map(fn g ->
  [char] =
    Enum.reduce(g, &MapSet.intersection/2)
    |> MapSet.to_list()

  char +
    if char in ?A..?Z do
      -?A + 27
    else
      -?a + 1
    end
end)
|> Enum.sum()
|> IO.puts()
