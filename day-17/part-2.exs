# NOTE: not optimized enough and unfinished

defmodule Cycled do
  def new(elems), do: {elems, []}

  def next({[], acc}) do
    next({Enum.reverse(acc), []})
  end

  def next({[next | rest], acc}) do
    {{rest, [next | acc]}, next}
  end

  def at_start?({[], _}), do: true
  def at_start?({_, []}), do: true
  def at_start?({_, _}), do: false
end

defmodule M do
  def next_rock(_, {rocks, moves, placed}) do
    {rocks, rock} = Cycled.next(rocks)
    rock = init_rock(rock, placed)

    {rock, moves} = drop_rock(rock, moves, placed)
    placed = MapSet.union(placed, MapSet.new(rock))
    
    acc = {rocks, moves, placed}
    
    if Cycled.at_start?(rocks) and Cycled.at_start?(moves) do
      {:halt, acc}
    else
      {:cont, acc}
    end
  end

  def init_rock(rock, placed) do
    y_offset =
      Enum.max(placed, fn {_, y1}, {_, y2} -> y1 >= y2 end, fn -> {0, -1} end)
      |> elem(1)
      |> then(&(&1 + 1))

    Enum.map(rock, fn {x, y} -> {x, y + y_offset} end)
  end

  def drop_rock(rock, moves, placed) do
    {moves, move} = Cycled.next(moves)
    pushed = move_rock(rock, {move, 0})

    rock =
      if in_bounds?(placed, pushed) do
        pushed
      else
        rock
      end

    fallen = move_rock(rock, {0, -1})

    if in_bounds?(placed, fallen) do
      drop_rock(fallen, moves, placed)
    else
      {rock, moves}
    end
  end

  def move_rock(rock, {dx, dy}) do
    Enum.map(rock, fn {x, y} -> {x + dx, y + dy} end)
  end

  def in_bounds?(placed, rock) do
    out_of_bounds =
      Enum.any?(rock, fn {x, y} -> x < 0 or x > 6 or y < 0 end) or
        Enum.any?(rock, &MapSet.member?(placed, &1))

    not out_of_bounds
  end

  def pretty_print(placed) do
    Enum.sort(placed, fn {_, y1}, {_, y2} -> y1 >= y2 end)
    |> Enum.chunk_by(&elem(&1, 1))
    |> Enum.map(fn line ->
      Enum.map(line, &elem(&1, 0))
      |> Enum.sort()
      |> render_line()
    end)
  end

  def render_line(_, rendered \\ [], x \\ 0)

  def render_line([], rendered, _) do
    Enum.reverse([?\n | rendered])
  end

  def render_line([next | rest] = all, rendered, x) do
    if next === x do
      render_line(rest, [?█ | [?█ | rendered]], x + 1)
    else
      render_line(all, [?\s | [?\s | rendered]], x + 1)
    end
  end
end

rocks =
  [
    [{2, 3}, {3, 3}, {4, 3}, {5, 3}],
    [{3, 3}, {2, 4}, {3, 4}, {4, 4}, {3, 5}],
    [{2, 3}, {3, 3}, {4, 3}, {4, 4}, {4, 5}],
    [{2, 3}, {2, 4}, {2, 5}, {2, 6}],
    [{2, 3}, {3, 3}, {2, 4}, {3, 4}]
  ]
  |> Cycled.new()

input =
  File.read!("i")
  |> String.trim()
  |> to_charlist()
  |> Enum.map(fn x -> x - ?= end)
  |> Cycled.new()

stack =
  1..100000000000
  |> Enum.reduce_while({rocks, input, MapSet.new()}, &M.next_rock/2)
  |> elem(2)

M.pretty_print(stack)
|> IO.write()
