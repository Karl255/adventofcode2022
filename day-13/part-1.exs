defmodule H do
  def compare(l, r) when is_number(l) and is_number(r) do
    l - r
  end

  def compare([], []), do: 0
  def compare([], [_ | _]), do: -1
  def compare([_ | _], []), do: 1

  def compare([l | l_rest], [r | r_rest]) do
    case r = compare(l, r) do
      0 -> compare(l_rest, r_rest)
      _ -> r
    end
  end

  def compare(l, r) when is_list(l) and is_number(r) do
    compare(l, [r])
  end

  def compare(l, r) when is_number(l) and is_list(r) do
    compare([l], r)
  end
end

File.read!("i")
|> String.trim()
|> String.split("\n\n")
|> Enum.map(fn pair ->
  String.split(pair, "\n")
  |> Enum.map(&elem(Code.eval_string(&1), 0))
  |> List.to_tuple()
end)
|> Enum.with_index(1)
|> Enum.map(fn {{l, r}, i} ->
  (H.compare(l, r) <= 0 && i) || 0
end)
|> Enum.sum()
|> IO.puts()
