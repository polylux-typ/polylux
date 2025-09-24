#import "../../../src/polylux.typ": *
#set text(size: 30pt, font: "Atkinson Hyperlegible")

#set page(
  paper: "presentation-16-9",
  margin: 2cm,
  header: align(
    top,
    toolbox.full-width-block(fill: aqua, inset: 8pt)[I'm up high],
  ),
  footer: align(
    bottom,
    toolbox.full-width-block(fill: lime, inset: 8pt)[I'm down low],
  ),
)

#slide[
  #lorem(10)
]
