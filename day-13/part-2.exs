import Kernel, except: [inspect: 2]

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

packets =
  File.read!("i")
  |> String.split("\n", trim: true)
  |> Enum.map(&elem(Code.eval_string(&1), 0))
  |> then(&Enum.concat(&1, [[[2]], [[6]]]))
  |> Enum.sort(&(H.compare(&1, &2) < 0))

x = Enum.find_index(packets, &(&1 === [[2]])) + 1
y = Enum.find_index(packets, &(&1 === [[6]])) + 1
IO.puts(x * y)
