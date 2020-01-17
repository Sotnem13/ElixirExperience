defmodule GeneticAlgorithm do

  # defmodule Params do
  #   defstruct
  #     mutation_rate: 0.1,
  #     parents_count: 2,
  #     population_count: 100,
  #     fitness: fn n -> 0 end,
  #     crossover: fn [a|_] -> a; a -> a end,
  #     mutate: fn a -> a end,
  #     random_gen: fn -> nil end,
  #     population: []
  # end

  # defmodule GenInfo do
  #   defstruct gen: nil, fitness: nil
  # end


  # def init_population(%Params{} = p) do

    # population = for _ <- 1..(p.population_count) do
    #   gen = p.random_gen.()
    #   %GenInfo{gen: gen}
    # end

  # end

  # %Params

  def main() do
  end

  def id(x) do
    x
  end



  def expression() do
    x = {:var, :x}
    {:-, {:*, x, x}, {:num, 4}}
  end

  def eval(expression, vars) do
    expression
    |> replaceVar(vars)
    |> eval()
  end

  def eval(expression) do
    case expression do
      {:*, a, b} -> eval(a)*eval(b)
      {:/, a, b} -> eval(a)/eval(b)
      {:-, a, b} -> eval(a)-eval(b)
      {:+, a, b} -> eval(a)+eval(b)
      {:num, a}  -> a
    end
  end

  def replaceVar(expression, vars) do
    case expression do
      {:var, x} -> {:num, vars[x]}
      {op, a, b} -> {op, replaceVar(a, vars), replaceVar(b, vars)}
      a -> a
    end
  end

end
