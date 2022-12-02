File.read!("i")
|> String.split("\n")
|> Enum.map(fn <<opponent, _, response>> ->
  opponent = opponent - ?A
  response = response - ?X

  response + 1 +
    3 * rem(response - opponent + 4, 3)
end)
|> Enum.sum()
|> IO.puts()
