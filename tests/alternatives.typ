#import "../polylux.typ": *

#set page(paper: "presentation-16-9")
#slide[
  == Test that `start` works

  #alternatives(start: 2)[abc ][def ][ghi ]

]

#slide[
  == Test that `repeat-last` works

  #alternatives[abc ][def ][ghi ]

  #alternatives(repeat-last: true)[jkl ][mno ][this stays ]

  #uncover(5)[You can go now.]
]

#slide[
  == Test that `alternatives-match` works

  #alternatives-match(
    position: center,
    (
      "-2": [beginning],
      "3, 5": [main part],
      "4": [short break],
      "6-": [end],
    ),
  )

  #uncover("1-8")[I am always here, for technical reasons.]
]

#slide[
  == Another test that `alternatives-match` works

  #alternatives-match(
    position: center,
    (
      (2, [beginning]),
      ((3, 5), [main part]),
      (4, [short break]),
      ("6-", [end]),
    ),
  )

  #uncover("1-8")[I am always here, for technical reasons.]
]

#slide[
  == Test that `alternatives-cases` works

  #alternatives-cases(
    ("1,3,4", "2,5", "6"),
    case => {
      set text(fill: lime) if case == 1
      lorem(10)
    },
  )
]

#slide[
  // == Test that `alternatives-fn` works

  // #raw(lang: "typ", repr(range(1, 6)))

  // #alternatives-fn(start: 2, count: 5, subslide => numbering("(i)", subslide))

  #only(2)[abc]
]
