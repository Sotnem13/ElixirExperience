defmodule Drop do
  @moduledoc """
  Documentation for Drop.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Drop.hello()
      :world

  """

  def test_fn(a) do
    case a do
      5 -> :five
      5.5 -> :ff
      10.0 -> :ten
      _ -> :unknown
    end
  end

  def eval(a) when is_number(a) do
    a
  end

  def eval({comand, a}) do
    # {a, b} = args
    a = eval(a)
    case comand do
      :sqrt -> sqrt(a)
    end
  end

  def eval({comand, a, b}) do
    # {a, b} = args
    a = eval(a)
    b = eval(b)
    case comand do
      :+ -> a + b
      :* -> a * b
      :- -> a - b
      :/ -> a / b
    end
  end



  defp delta, do:  1.0e-10
  defp tolerance, do:  1.0e-10

  def pair(a, b), do: {a, b}
  def first({a, b}), do: a
  def second({a, b}), do: b

  def count(from, to)  do
    d = to - from
    dir = div(d, abs(d))
    count(from, to, dir)
  end

  defp count(from, to, dir) when from != to do
    IO.puts(from)
    count(from + dir, to, dir)
  end

  defp count(from, to, dir) do
    IO.puts "Finish"
  end

  def fixed_point(func, guess) do

      yc = fn f ->
          (fn x -> x.(x) end).
          (
             fn y ->
               f.(fn arg -> y.(y).(arg) end)
             end
          )
      end

      # close_enough = fn guess ->  abs(func.(guess) - guess) <  end
      close_enough = &(abs(&1 - &2) < tolerance())
      # try_guess = fn _ -> 5 end
      try_guess = fn guess, try_guess ->
        next = func.(guess)
        if close_enough.(next, guess), do: next, else: try_guess.(next, try_guess)
      end

      # fn f, x -> &(f.(&1, x)) end

      try_guess.(guess, try_guess)
      # try_guess(guess)
  end

  # defp try_guess

  def main do
    # y = sin(y) + cos(y)
    f = &(:math.cos(&1) + :math.sin(&1))
    fixed_point(f, 1)
  end

  def sqrt1(x) do
    # y = x / y

  end


  # def abs(x), do: if x < 0, do: -x, else: x


  def sqrt_good_enough?(x, y) do
    abs(x*x - y) < delta
  end

  defp sqrt_iter(x, res) do
    if (sqrt_good_enough?(res, x)) do
      res
    else
      res = (res + x / res) / 2
      sqrt_iter(x, res)
    end
  end

  def sqrt(x) do
    sqrt_iter(x, 1)
  end

  def parse('0'), do: 0
  def parse('1'), do: 1
  def parse('2'), do: 2

  def parse([x, xs]), do: x

end
