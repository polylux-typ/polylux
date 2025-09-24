#import "../../../src/polylux.typ": *
#set text(size: 40pt, font: "Atkinson Hyperlegible")

#set page(
  paper: "presentation-16-9",
  header: toolbox.next-heading(h => underline(h)),
)

#show heading.where(level: 1): none

#set align(horizon)

#slide[
  = My slide title

  #lorem(10)
]

#slide[
  slide without a title
]

#slide[
  = Another title

  #lorem(10)
]

