#import "../../../src/polylux.typ": *
#set page(paper: "presentation-16-9")
#set text(size: 40pt, font: "Atkinson Hyperlegible")

#slide[
  #uncover(3, mode: gray)[abc]

  #one-by-one(start: 2, mode: gray)[def ][ghi]

  #item-by-item(mode: gray)[
    - jkl
    - mno
  ]

  #show: later.with(mode: gray)
  pqr

]
