File.stream!("i")
|> Enum.map(&String.trim/1)
|> Enum.flat_map(fn ins ->
  cond do
    String.starts_with?(ins, "addx") -> ["prep", ins]
    true -> [ins]
  end
end)
|> Enum.reduce({1, 1, 0}, fn <<op::binary-size(4), arg::binary>>, {cycle, x, signal} ->
  arg =
    if arg !== "" do
      String.to_integer(String.trim(arg))
    else
      nil
    end

  signal = signal + if rem(cycle, 40) === 20, do: cycle * x, else: 0

  case op do
    "addx" -> {cycle + 1, x + arg, signal}
    _ -> {cycle + 1, x, signal}
  end
end)
|> then(&elem(&1, 2))
|> IO.puts()
