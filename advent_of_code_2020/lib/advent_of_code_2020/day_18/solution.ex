defmodule AdventOfCode2020.Day18.Solution do
  defmodule MyOperatorPartOne do
    @moduledoc false

    def a / b do
      a + b
    end
  end

  defmodule MyOperatorPartTwo do
    @moduledoc false

    def a / b do
      a + b
    end

    def a - b do
      a * b
    end
  end

  @moduledoc """
  As you look out the window and notice a heavily-forested continent slowly appear over the horizon, you are interrupted by the child sitting next to you. They're curious if you could help them with their math homework.

  Unfortunately, it seems like this "math" follows different rules than you remember.

  The homework (your puzzle input) consists of a series of expressions that consist of addition (+), multiplication (*), and parentheses ((...)). Just like normal math, parentheses indicate that the expression inside must be evaluated before it can be used by the surrounding expression. Addition still finds the sum of the numbers on both sides of the operator, and multiplication still finds the product.

  However, the rules of operator precedence have changed. Rather than evaluating multiplication before addition, the operators have the same precedence, and are evaluated left-to-right regardless of the order in which they appear.

  1 + 2 * 3 + 4 * 5 + 6
    3   * 3 + 4 * 5 + 6
        9   + 4 * 5 + 6
            13   * 5 + 6
                65   + 6
                      71

  Parentheses can override this order; for example, here is what happens if parentheses are added to form 1 + (2 * 3) + (4 * (5 + 6))

  1 + (2 * 3) + (4 * (5 + 6))
  1 +    6    + (4 * (5 + 6))
     7      + (4 * (5 + 6))
     7      + (4 *   11   )
     7      +     44
            51


  """
  @type file_path :: String.t()

  @doc """
  Before you can help with the homework, you need to understand it yourself. Evaluate the expression on each line of the homework; what is the sum of the resulting values?
  """
  @spec part_one(file_path) :: integer
  def part_one(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&parse_line_part_one/1)
    |> Stream.map(&calculate_line_part_one/1)
    |> Enum.reduce(0, fn {value, _}, acc -> acc + value end)
  end

  defp parse_line_part_one(line) do
    line
    |> String.trim()
    |> String.replace("+", "/")
  end

  defp calculate_line_part_one(line) do
    import Kernel, only: [*: 2]
    import AdventOfCode2020.Day18.Solution.MyOperatorPartOne, only: [/: 2]
    _unused = fn -> 1 / 2 end

    Code.eval_string(line, [], __ENV__)
  end

  @doc """
  You manage to answer the child's questions and they finish part 1 of their homework, but get stuck when they reach the next section: advanced math.

  Now, addition and multiplication have different precedence levels, but they're not the ones you're familiar with. Instead, addition is evaluated before multiplication.

  For example, the steps to evaluate the expression 1 + 2 * 3 + 4 * 5 + 6 are now as follows:

  1 + 2 * 3 + 4 * 5 + 6
  3   * 3 + 4 * 5 + 6
  3   *   7   * 5 + 6
  3   *   7   *  11
     21       *  11
         231

  What do you get if you add up the results of evaluating the homework problems using these new rules?
  """
  @spec part_two(file_path) :: integer
  def part_two(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&parse_line_part_two/1)
    |> Stream.map(&calculate_line_part_two/1)
    |> Enum.reduce(0, fn {value, _}, acc -> acc + value end)
  end

  defp parse_line_part_two(line) do
    line
    |> String.trim()
    |> String.replace("+", "/")
    |> String.replace("*", "-")
  end

  defp calculate_line_part_two(line) do
    import Kernel, only: []
    import AdventOfCode2020.Day18.Solution.MyOperatorPartTwo, only: [/: 2, -: 2]
    _unused = fn -> 1 / 2 - 3 end

    Code.eval_string(line, [], __ENV__)
  end
end
