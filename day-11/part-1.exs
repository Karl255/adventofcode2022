# this isn't working for some reason
# monkey_regex =
#  ~r/Monkey (\d+):\n  Starting items: ([\d,\s]+)\n  Operation: new = ([a-z\d\+\* ]+)old * 19\n  Test: divisible by (\d+)\n    If true: throw to monkey (\d+)\n    If false: throw to monkey (\d+)/

_comment = """
File.read!("i")
|> String.split("\n\n", trim: true)
|> Enum.map(&String.trim/1)
|> Enum.map(fn monkey ->
  [_, id, starting_items, operation, test, if_true, if_false] = Regex.run(monkey_regex, monkey)
  
  %{
    id: String.to_integer(id),
    starting_items: String.split(starting_items, ", ") |> Enum.map(&String.to_integer/1),
    operation: operation,
    test: String.to_integer(test),
    if_true: String.to_integer(if_true),
    if_false: String.to_integer(if_false)
  }
end)
|> IO.inspect(pretty: true, syntax_colors: IO.ANSI.syntax_colors())
"""

_initial_monkeys = [
  %{
    id: 0,
    items: [79, 98],
    operation: &(&1 * 19),
    test: 23,
    if_true: 2,
    if_false: 3,
    inspects: 0
  },
  %{
    id: 1,
    items: [54, 65, 75, 74],
    operation: &(&1 + 6),
    test: 19,
    if_true: 2,
    if_false: 0,
    inspects: 0
  },
  %{
    id: 2,
    items: [79, 60, 97],
    operation: &(&1 * &1),
    test: 13,
    if_true: 1,
    if_false: 3,
    inspects: 0
  },
  %{
    id: 3,
    items: [74],
    operation: &(&1 + 3),
    test: 17,
    if_true: 0,
    if_false: 1,
    inspects: 0
  }
]

initial_monkeys = [
  %{
    id: 0,
    items: [54, 61, 97, 63, 74],
    operation: &(&1 * 7),
    test: 17,
    if_true: 5,
    if_false: 3,
    inspects: 0
  },
  %{
    id: 1,
    items: [61, 70, 97, 64, 99, 83, 52, 87],
    operation: &(&1 + 8),
    test: 2,
    if_true: 7,
    if_false: 6,
    inspects: 0
  },
  %{
    id: 2,
    items: [60, 67, 80, 65],
    operation: &(&1 * 13),
    test: 5,
    if_true: 1,
    if_false: 6,
    inspects: 0
  },
  %{
    id: 3,
    items: [61, 70, 76, 69, 82, 56],
    operation: &(&1 + 7),
    test: 3,
    if_true: 5,
    if_false: 2,
    inspects: 0
  },
  %{
    id: 4,
    items: [79, 98],
    operation: &(&1 + 2),
    test: 7,
    if_true: 0,
    if_false: 3,
    inspects: 0
  },
  %{
    id: 5,
    items: [72, 79, 55],
    operation: &(&1 + 1),
    test: 13,
    if_true: 2,
    if_false: 1,
    inspects: 0
  },
  %{
    id: 6,
    items: [63],
    operation: &(&1 + 4),
    test: 19,
    if_true: 7,
    if_false: 4,
    inspects: 0
  },
  %{
    id: 7,
    items: [72, 51, 93, 63, 80, 86, 81],
    operation: &(&1 * &1),
    test: 11,
    if_true: 0,
    if_false: 4,
    inspects: 0
  }
]

Enum.reduce(1..20, initial_monkeys, fn _, round_initial_monkeys ->
  Enum.reduce(0..(length(initial_monkeys) - 1), round_initial_monkeys, fn i, monkeys ->
    monkey = Enum.at(monkeys, i)

    Enum.reduce(monkey.items, monkeys, fn item, all_monkeys ->
      worry_level = div(monkey.operation.(item), 3)

      to_monkey =
        if rem(worry_level, monkey.test) === 0 do
          monkey.if_true
        else
          monkey.if_false
        end

      List.update_at(all_monkeys, i, fn m ->
        Map.update!(m, :items, fn l -> Enum.reject(l, &(&1 === item)) end)
        |> Map.update!(:inspects, &(&1 + 1))
      end)
      |> List.update_at(to_monkey, fn m ->
        Map.update!(m, :items, &(&1 ++ [worry_level]))
      end)
    end)
  end)
end)
|> Enum.map(&Map.get(&1, :inspects))
|> Enum.sort(:desc)
|> Enum.take(2)
|> Enum.product()
|> IO.puts()
