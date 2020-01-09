defmodule NumParser do


    def num([a | b]), do: {a, b}

    def num("") do
      {nil, ""}
    end


end
