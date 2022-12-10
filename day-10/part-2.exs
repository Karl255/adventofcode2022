File.stream!("i")
|> Enum.map(&String.trim/1)
|> Enum.flat_map(fn ins ->
  cond do
    String.starts_with?(ins, "addx") -> ["prep", ins]
    true -> [ins]
  end
end)
|> Enum.reduce({0, 1, ""}, fn <<op::binary-size(4), arg::binary>>, {cycle, x, signal} ->
  arg =
    if arg !== "" do
      String.to_integer(String.trim(arg))
    else
      nil
    end

  signal = signal <> if rem(cycle, 40) in (x - 1)..(x + 1), do: "██", else: "  "

  case op do
    "addx" -> {cycle + 1, x + arg, signal}
    _ -> {cycle + 1, x, signal}
  end
end)
|> then(&to_charlist(elem(&1, 2)))
|> Enum.chunk_every(2 * 40)
|> Enum.intersperse(?\n)
|> then(&List.to_string/1)
|> IO.puts()
