#import "../../../src/polylux.typ": *
#set page(paper: "presentation-16-9")
#set text(size: 30pt, font: "Atkinson Hyperlegible")

#slide[
  #only((
    beginning: 1,
    until: 5,
  ))[Content displayed on subslides 1, 2, 3, 4, and 5 \ ]
  #only((
    beginning: 2,
  ))[Content displayed on subslide 2 and every following one \ ]
  #only((until: 3))[Content displayed on subslides 1, 2, and 3 \ ]
  #only((:))[Content that is always displayed]
]
