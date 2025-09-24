#import "../../../src/polylux.typ": *
#set page(paper: "presentation-16-9")
#set text(size: 35pt, font: "Atkinson Hyperlegible")

#slide[
  #show: columns.with(3)

  #set list(marker: sym.arrow)
  #item-by-item[
    - first
    - second
      - some
      - detail
    - third
  ]
  #colbreak()

  #item-by-item[
    + also
    + works
    + with `enums`
  ]
  #colbreak()

  #item-by-item(start: 2)[
    / and: with
    / terms: too
  ]
]
