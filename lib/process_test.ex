defmodule ProcessTest do

  def start_reporter(state \\[]) do
    spawn(__MODULE__,:report,state)
  end

  def report do
    command = receive do
      13 -> throw "13 =)"
      {:msg, msg} -> IO.puts("Received #{msg}"); :receive
    after 10_000 -> IO.puts("10 seconds passed, no messages"); :exit
    end
    report(command)
  end

  def report(:exit), do: nil

  def report(_), do: report


  defmacro solve(code) do
    IO.inspect(code)

    case code do
      {:=, _, [lhs, rhs]} -> {a, b} = solve_(lhs, rhs); {:=, [],[a, b]}
      _ -> nil
    end
  end

  defp solve_(lhs, rhs) do
    #  IO.inspect(lhs)
    case lhs do
      {:*, _, [a, b]} ->
        if has_var?(a) do
          solve_(a, {:/, [], [rhs, b]})
        else
          solve_(b, {:/, [], [rhs, a]})
        end

        {:-, _, [a, b]} ->
          if has_var?(a) do
            solve_(a, {:+, [], [rhs, b]})
          else
            solve_(b, {:+, [], [rhs, a]})
          end
        {:+, _, [a, b]} ->
          if has_var?(a) do
              solve_(a, {:-, [], [rhs, b]})
            else
              solve_(b, {:-, [], [rhs, a]})
            end
            {:/, _, [a, b]} ->
              if has_var?(a) do
                  solve_(a, {:*, [], [rhs, b]})
                else
                  solve_(b, {:*, [], [rhs, a]})
                end
      {var, _, nil} -> {lhs, rhs}
      a when is_number(a) -> a
    end
  end

  defp has_var?({a, _, b}) when is_atom(a) do
    # IO.inspect({a, b})
      case b do
        [a, b] -> has_var?(a) ||  has_var?(b)
        [a] ->  has_var?(a)
        nil -> true
        _ -> false
      end
  end

  defp has_var?(a), do: false


  def main do
    solve(x / 2 - 2 = 13)
    x
  end


end
