defmodule Lambda do
  def rand(n) do
    :rand.uniform(n)
  end

  # def random_var


  def gen(:var, _) do
    <<z>> = "0"
    {:var, "var" <> <<z + rand(10) - 1>>}
  end

  def gen(:lam, depth) do
    {:lam, gen(:var, 0), gen(:term, depth - 1)}
  end

  def gen(:app, depth) do
    {:app, gen(:lam, depth - 1), gen(:term, depth - 1)}
  end

  def gen(:term, depth) when depth < 0 do
      gen(:var, 0)
  end

  def gen(:term, depth) do
    case rand(2) do
      2 -> gen(:app, depth)
      1 -> gen(:lam, depth)
    end
  end

  def gen(:number) do
    rand(1000)
  end

  def gen() do

  end

  def free_vars(term) do
    vars = fn _ -> false end
    free_vars(term, vars)
  end

  def free_vars({:var,v}, has_var) do
    if (has_var.(v)) do
      []
    else
      [v]
    end
  end

  def free_vars({:lam,v, term}, has_var) do
    vars = fn x-> x == v || has_var.(x) end
    free_vars(term, vars)
  end

  def free_vars({:app, term1, term2}, has_var) do
    free_vars(term1, has_var) ++ free_vars(term2, has_var)
    |> Enum.uniq()
  end

  def to_scope([a | t]) do
    [{String.to_atom(a), a} | to_scope(t)]
  end
  def to_scope([]) do
    []
  end


  def to_fn(term) do
    code = {:lam, {:var, ""}, term}
    |> to_fn_str()
    scope = free_vars(term) |> to_scope
    Code.eval_string(code, scope)
  end

  def to_fn_str({:var, v}) do
    v
  end

  def to_fn_str({:lam, v, term}) do
      "fn "<> to_fn_str(v) <> "-> " <> to_fn_str(term) <> " end"
  end

  def to_fn_str({:app, lam, term}) do
    to_fn_str(lam) <> ".(" <> to_fn_str(term) <> ")"
  end

  def term_to_string({:var, v}) do
    v
  end

  def term_to_string({:lam, v, term}) do
    "("<> term_to_string(v) <> ")->{" <> term_to_string(term) <> "}"
  end

  def term_to_string({:app, lam, term}) do
    term_to_string(lam) <> "(" <> term_to_string(term) <> ")"
  end


  def main do
    # Code.eval_string("a = 3 + b", [b: 3])
  end

  def por({x,y}, z) do
    y / x * z
  end



  # term :: Parser Term
  # term = lam <|> (app <|> var)
  #
  # lam =  (\_ v _ _ _ t -> Lam v t)
  #    <$> char '\\'
  #    <*> (many $ matching (\c -> c <= 'z' && c >= 'a' ))
  #    <*> char ' '
  #    <*> char '.'
  #    <*> char ' '
  #    <*> term
  #
  # app =  (\_ t1 _ t2 _ -> App t1 t2)
  #    <$> char '('
  #    <*> term
  #    <*> char ' '
  #    <*> term
  #    <*> char ')'
  #
  # var = Var <$> (many $ matching (\c -> c <= 'z' && c >= 'a' ))
  #
  # toTerm :: Either Err (Term,String) -> Term
  # toTerm p = case p of
  #   Right (a,s) -> a
  #
  # canBeEvaluated :: Term -> Bool
  # canBeEvaluated t = case t of
  #   App (Lam v t1) t2 -> True
  #   App t1 t2 -> canBeEvaluated t1 || canBeEvaluated t2
  #   Lam v t -> canBeEvaluated t
  #   otherwise -> False
  #
  # getVars = (\t -> case t of
  #   Var x -> (\c -> c == x)
  #   App t1 t2 -> (\c -> (getVars t1) c || (getVars t2) c)
  #   _ -> (\c -> False))
  #
  # replaceVar = \t v1 v2 -> case t of
  #   Var v -> Var (if v1 == v then v2 else v)
  #   Lam v t2 -> if v1 == v then (Lam v2 (replaceVar t2 v v2) ) else (Lam v (replaceVar t2 v1 v2))
  #   App t1 t2 -> App (replaceVar t1 v1 v2) (replaceVar t2 v1 v2)
  #
  # newVar = \x k -> if k (x++x) then newVar (x++x) k else x++x
  #
  # eval1' :: Term -> (String -> Bool) -> Term
  #
  # eval1' t k = if canBeEvaluated t then eval1' (case t of
  #   App (Lam v t1) t2 -> case t1 of
  #     App t3 t4 -> App (eval1' (App (Lam v t3) t2) k) (eval1' (App (Lam v t4) t2) k)
  #     Var v1 -> if v1 == v then t2 else t1
  #     Lam v1 t3 -> if ((getVars t2) v1) then
  #       Lam (newVar v1 (getVars t2)) (eval1' (App (Lam v (replaceVar t3 v1 (newVar v1 (getVars t2)))) t2) (\c -> k c || (getVars t2) c)  )
  #       else Lam v1 (eval1' (App (Lam v t3) t2) k)
  #   App t1 t2 -> App (eval1' t1 k) (eval1' t2 k)
  #   Lam v  t1 -> Lam v (eval1' t1 k)
  #   Var x -> Var (if k x then newVar x k else x) ) k else t
  #
  # eval :: Term -> Term
  # eval t = eval1' t (\a -> False )

# \x .
#
# (\x . x)(z) = z
# (\x . y)(z) = y
# (\a . ((\x . x)(z))) (z)
# (\a . \z . z) (z) = \zz . (\a . zz)(z) = \zz . zz
# (\a . \z . z) (zz) = \z . (\a . z)(zz) = \z . z

# (\a  (\c . c)(\b . a) )(z) = ((\a . (\c . c))(z))  ((\a . \b . a)(z)) = (\c . c)(\b . z)
# (\a  (\c . c)(\b . a) )(z) = (\b . z)

# eval_step t = case t of
#   App (Lam v t1) t2 -> case t1 of
#     App t3 t4 -> App (eval1 (App (Lam v t3) t2) k) (eval1 (App (Lam v t4) t2) k)
#     Var v1 -> if v1 == v then t2 else t1
#     Lam v1 t3 -> if ((getVars t2) v1) then
#       Lam (newVar v1 (getVars t2)) (eval1 (App (Lam v (replaceVar t3 v1 (newVar v1 (getVars t2)))) t2) (\c -> k c || (getVars t2) c)  )
#       else Lam v1 (eval1 (App (Lam v t3) t2) k)
#   App t1 t2 -> App (eval1 t1 k) (eval1 t2 k)
#   Lam v  t1 -> Lam v (eval1 t1 k)
#   Var x -> Var (if k x then newVar x k else x)
#
# eval2 t k = eval1 (eval_step t k) k
#
#   eval1 t k = if canBeEvaluated t then eval2 t k else t

end
