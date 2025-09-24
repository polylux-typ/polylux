#import "../../../src/polylux.typ": *
#set page(paper: "presentation-16-9")
#set text(size: 40pt, font: "Atkinson Hyperlegible")

#slide[
  #only(1)[Ann] #only(2)[Bob] #only(3)[Christopher]
  likes
  #only(1)[chocolate] #only(2)[strawberry] #only(3)[vanilla]
  ice cream.

  #repeat[| #h(4cm)] // visual reference
]
