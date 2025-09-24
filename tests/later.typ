#import "../polylux.typ": *

#set page(paper: "presentation-16-9")

// #enable-handout-mode(true)

#slide[
  == Text like content

  Hello
  #show: later
  $a + b$
  #uncover("4-")[uncovered]
  #show: later
  $ integral f(x) dif x $
  #show: later

  - *item1*
  - _item2_
  #show: later
  - `item3`

  #show: later

  + #underline[item1]
  + #strike[item2]
  + #overline[item3]

  #show: later

  / def1: abc
  / def2: ghi

  #show: later

  #box(stroke: 2pt + aqua, inset: 2pt)[boxed!]

  #show: later

  #block(stroke: 2pt + lime, inset: 2pt)[blocked!]
]

#slide[
  == Multiple scopes

  #grid(columns: 2, gutter: 1em)[
    abc
    #show: later
    def
  ][
    ghi
    #show: later.with(strand: 2)
    jkl
    #show: later.with(strand: 2)
    mno
  ]
]

#slide[
  == Visuals

  #show: later

  // Fails to be hidden as of Typst 0.7.0
  #path(
    fill: teal.lighten(50%),
    stroke: teal,
    closed: true,
    (0cm, 0cm),
    (1cm, 0cm),
    (1cm, 1cm),
  )

  #rect()

  #square()

  #circle()

  #ellipse()

  // Fails to be hidden as of Typst 0.7.0
  #line()

  // Fails to be hidden as of Typst 0.7.0
  #polygon(
    fill: teal.lighten(50%),
    stroke: teal,
    (0cm, 0cm),
    (1cm, 0cm),
    (1cm, 1cm),
  )

  #image("../assets/polylux-logo.svg", width: 3em)
]

