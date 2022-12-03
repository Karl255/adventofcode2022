File.read!("i")
|> String.split("\n", trim: true)
|> Enum.map(fn l ->
  s = byte_size(l)

  [char] =
    to_charlist(l)
    |> Enum.chunk_every(div(s, 2))
    |> Enum.map(&MapSet.new/1)
    |> Enum.reduce(&MapSet.intersection/2)
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
