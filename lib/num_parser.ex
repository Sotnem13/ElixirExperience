defmodule NumParser do

    def num(""), do: {nil, ""}

    def num(a) do
      num(a, nil)
    end

    def num("", ac) do
      {ac, ""}
    end

    def num("-" <> rest, nil) do
      case num(rest, 0) do
        {nil, r} -> {nil, r}
        {val, r} -> {-val, r}
      end
    end

    def num(<<a::utf8, b::binary>>, ac) do
      <<zero, n>> = "09"
      ac = if (ac == nil), do: 0, else: ac
      cond do
        a >= zero && a <= n -> num(b, ac * 10 + a - zero)
        # "." == <<a>> -> {}
        true -> {ac, <<a::utf8, b::binary>>}
      end
    end

    def digit(<<a::utf8, b::binary>> = input) do
      <<z, n>> = "09"
      if a >= z && a <= n do
        {a - z, b}
      else
        {nil, input}
      end
    end

    def number do
      fn i ->
        case num(i) do
          {nil, _} -> {:error}
          {a, r} -> {{:num, a}, r}
        end
      end
    end

    # arith = plus <|> minus <|> expression

# plus  = (\a _ b -> Plus  a b) <$> expression <*> char '+' <*> arith
# minus = (\a _ b -> Minus a b) <$> expression <*> char '-' <*> arith
# expression = mul <|> num
# mul = (\a _ b -> Mul a b) <$> num <*> char '*' <*> expression
# num = ((\_ e _ -> e ) <$> char '(' <*> arith <*> char ')' ) <|> (Number <$> number)


    def arith() do
      &(plus() <|> minus() <|> expression()).(&1)
    end

    def plus() do
      fn a,_,b -> {:+, a, b} end
      |> app([expression(), char("+"), arith()])
    end
    def minus() do
      # fn i ->
        fn a,_,b -> {:-, a, b} end
        |> app([expression(), char("-"), arith()])
      # end
    end

    def mul() do
      fn a,_,b -> {:*, a, b} end
      |> app([num(), char("*"), expression()])
    end

    def expression() do
      &(mul() <|> num()).(&1)
    end

    def num() do
      fn _,e,_ -> e end
      |> app([char("("), arith(), char(")")])
      <|> number()
    end

    def char(<<a>>) do
      fn <<^a, t::binary>> -> {<<a>>, t}
         _ -> {:error}
      end
    end

    def app(f, [p]) do
      fn i ->
        case p.(i) do
          {:error} -> {:error}
          {r, rest} -> {f.(r), rest}
        end
      end
    end

    def app(f, [p | o]) do
      f = curry(f)
      fn i ->
        case p.(i) do
          {:error} -> {:error}
          {r, rest} -> (f.(r) |> app(o)).(rest)
        end
      end
    end

    def eval(term) do
      case term do
        {:+, a, b} -> eval(a) + eval(b)
        {:-, a, b} -> eval(a) - eval(b)
        {:*, a, b} -> eval(a) * eval(b)
        {:num, a} -> a
      end
    end

    def left <|> right do
      fn input ->
        case left.(input) do
          {:error} -> right.(input)
          a -> a
        end
      end
    end

    def curry(fun) do
      {_, arity} = :erlang.fun_info(fun, :arity)
      curry(fun, arity, [])
    end

    def curry(fun, 0, arguments) do
      apply(fun, Enum.reverse arguments)
    end

    def curry(fun, arity, arguments) do
      fn arg -> curry(fun, arity - 1, [arg | arguments]) end
    end


end
