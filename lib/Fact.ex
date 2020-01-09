defmodule Fact do


  def is_nil(nil), do: true
  def is_nil(_), do: false

  def fact(a) when a <= 1, do: 1

  def fact(n), do: n * fact(n - 1)


  def main() do

    error = fn n -> throw "Error func call" end

    improver = fn partial ->
      fn n ->
        if n == 0, do: 1, else: n * partial.(n-1)
      end
    end


    imp = fn f -> f.(f) end

    fib_ = fn fib ->
      fn n ->
        if n == 0, do: 1, else: n * fib.(n-1)
      end
    end

    f = fn rec ->
      fn f -> rec.(fn x-> f.(f).(x) end) end.(
      fn f -> rec.(fn x-> f.(f).(x) end) end )
    end.(fib_)




    # f = improver.(error)
    f.(100)


  end

end
