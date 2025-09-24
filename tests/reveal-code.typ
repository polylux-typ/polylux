#import "../polylux.typ": *

#set page(paper: "presentation-16-9")

#slide[
  #reveal-code(lines: (3, 4, 6), before: silver)[```julia
    function foo(x)
      @show x
      s = sum(x) do xi
        xi ^ 2 + 3
      end
      x ./ s
    end
    ```]
]
