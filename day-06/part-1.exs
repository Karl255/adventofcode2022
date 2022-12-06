defmodule H do
  def get_marker([_ | rest] = data, n, offset \\ 0) do
    size = Enum.take(data, n)
    |> MapSet.new()
    |> MapSet.size()
    
    if size < n do
      get_marker(rest, n, offset + 1)
    else
      offset + n
    end
  end
end

File.read!("i")
|> to_charlist()
|> H.get_marker(4)
|> IO.puts()
