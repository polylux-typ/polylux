#import "../../../src/polylux.typ": *
#set page(paper: "presentation-16-9")
#set text(size: 40pt, font: "Atkinson Hyperlegible")

#let sections-band = toolbox.all-sections((sections, current) => {
  set text(fill: gray, size: .8em)
  sections.map(s => if s == current { strong(s) } else { s }).join([ • ])
})

#set page(footer: sections-band)

#slide[
  #toolbox.register-section[The beginning]

  #lorem(5)
]

#slide[
  #lorem(3)
]


#slide[
  #toolbox.register-section[The middle]

  #lorem(6)
]

#slide[
  #toolbox.register-section[The end]

  #lorem(4)
]
