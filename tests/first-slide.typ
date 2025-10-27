#import "../polylux.typ": *

#set page(paper: "presentation-16-9", height: auto)
#set text(size: 25pt)

#let slide = polylux-slide

#slide[
  == First slide

  This is supposed to appear on the first PDF page.
]

#slide[
  == Second slide
  #lorem(10)
]
