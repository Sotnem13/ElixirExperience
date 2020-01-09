defmodule BinaryTree do


  defmodule Tree do
    defstruct left: nil, right: nil, key: nil, value: nil
  end


  def insert(%Tree{key: nil}, {key, value}) do
    %Tree{key: key, value: value}
  end

  def insert(nil, {key, value}) do
    %Tree{key: key, value: value}
  end

  def insert(t = %Tree{}, {key, value} = item) do
    new_tree = cond do
      t.key < key  -> %Tree{t | left: insert(t.left, item)}
      t.key > key  -> %Tree{t | right: insert(t.right, item)}
      t.key == key -> %Tree{t | value: value}
    end
    balance(new_tree)
  end

  def depth(nil), do: 0

  def depth(t = %Tree{}) do
    depth_l = depth(t.left)
    depth_r = depth(t.right)
    max(depth_r, depth_l) + 1
  end


  def balance(%Tree{} = t) do
    # t.
    t
  end

  def right_rotate(%Tree{left: %Tree{right: %Tree{left: m, right: n} = c} = b} = a) do
    b = %Tree{b | right: m}
    a = %Tree{a | left:  n}
    %Tree{c | left: b, right: a}
  end

  def right_rotate(t = %Tree{}), do: t

  def left_rotate(%Tree{right: %Tree{left: %Tree{left: m, right: n} = c} = b} = a) do
    a = %Tree{a | right: m}
    b = %Tree{b | left: n}
    %Tree{c | left: a, right: b}
  end

  def left_rotate(t = %Tree{}), do: t


  def get(%Tree{} = t, key) do
    cond do
      t.key == key -> t.value
      t.key < key -> get(t.left, key)
      t.key > key -> get(t.right, key)
    end
  end

  def get(nil, key) do
    nil
  end

  def insert({v1, ln, rn}, value) do
    if value < v1 do
      {v1, insert(ln, value), rn}
    else
      {v1, ln, insert(rn, value)}
    end
  end

  def insert({}, value) do
    {value, {}, {}}
  end

  def has({v1, ln, rn}, value) do
    v1 == value || has(ln, value) || has(rn, value)
  end

  def has({}, value), do: false

end
