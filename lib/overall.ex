defmodule Overall do

  def product([]) do
    0
  end

  def product(list) do
    product(list, 1)
  end

  def product([], accum) do
    accum
  end

  def product([head | tail], accum) do
    product(tail, accum*head)
  end

  def ttt([{a, b} | tail]) do
    a
  end

end
