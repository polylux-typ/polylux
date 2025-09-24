#import "../../../src/polylux.typ": *
#set page(paper: "presentation-16-9")
#set text(size: 50pt, font: "Atkinson Hyperlegible")

#slide[
  We are on subslide:
  #alternatives-fn(
    start: 2,
    count: 7,
    subslide => {
      numbering("(i)", subslide)
    },
  )
]
