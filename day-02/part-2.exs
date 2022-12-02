File.read!("i")
|> String.split("\n")
|> Enum.map(fn <<opponent, _, response>> ->
  opponent = opponent - ?A
  response = response - ?X

  rem(response - 2 * opponent + 5, 3) + 1 +
    3 * response
end)
|> Enum.sum()
|> IO.puts()
