#import "../src/polylux.typ": *

#show link: set text(blue)
#set text(font: "Andika", size: 20pt)
#show raw: set text(font: "Fantasque Sans Mono")
#show math.equation: set text(font: "Lete Sans Math")

#let my-stroke = stroke(
  thickness: 2pt,
  paint: blue.lighten(50%),
  cap: "round",
)

#set page(
  paper: "presentation-16-9",
  margin: 2cm,
  footer: [
    #set text(size: .6em)
    #set align(horizon)

    Andreas Kröpelin, January 2025 #h(1fr) #toolbox.slide-number
  ],
  header: box(stroke: (bottom: my-stroke), inset: 8pt)[
    #set text(size: .6em)
    #set align(horizon)
    // #box(image("../assets/polylux-logo.svg", height: 2em))
    #h(1fr)
    Polylux demo | #toolbox.current-section
  ],
)

#show heading: set block(below: 2em)

#let new-section-slide(title) = slide[
  #set page(footer: none, header: none)
  #set align(horizon)
  #set text(size: 1.5em)
  #strong(title)
  #line(stroke: my-stroke, length: 50%)
  #toolbox.register-section(title)
]

#slide[
  #set page(footer: none, header: none)
  #set align(horizon)
  #text(size: 2em, weight: "bold")[
    #toolbox.side-by-side(columns: (auto, 1fr))[
      #image("../assets/polylux-logo.svg", height: 2em)
    ][
      Polylux \ Easily creating slides in Typst
    ]
  ]

  #line(stroke: my-stroke, length: 100%)

  An overview over all the features

  Andreas Kröpelin, January 2025
]

#new-section-slide("Introduction")

#slide[
  = About this presentation
  This presentation is supposed to briefly showcase what you can do with this
  package.

  For a full documentation, read the
  #link("https://polylux.dev/book/")[online book].
]

#slide[
  = A title
  Let's explore what we have here.

  On the top of this slide, you can see the slide title.

  We used a simple level-one heading for that.
]

#slide[
  Titles are not mandatory, this slide doesn't have one.

  But did you notice that the current section name is displayed above that top
  line?

  We defined it using
  #raw("#toolbox.register-section(\"Introduction\")", lang: "typst", block: false).

  This helps our audience with not getting lost after a microsleep.

  You can also spot a short title next to that.
]

#slide[
  = The bottom of the slide
  Now, look down!

  There we have some general info for the audience about what talk they are
  actually attending right now.

  You can also see the slide number there.
]


#new-section-slide("Dynamic content")


#slide[
  = A dynamic slide with `#show: later`
  Sometimes we don't want to display everything at once.
  #show: later

  That's what the `#show: later` feature is there for!
  #show: later

  It makes everything after it appear at the next subslide.

  #set text(size: .6em)
  (Also note that the slide number does not change while we are here.)
]

#slide[
  = Fine-grained control
  When `#show: later` does not suffice, you can use more advanced commands to
  show or hide content.

  These are some of your options:
  - `#uncover`
  - `#only`
  - `#alternatives`
  - `#one-by-one`
  - `#item-by-item`

  Let's explore them in more detail!
]

#let example(body) = block(
  width: 100%,
  inset: .5em,
  fill: aqua.lighten(80%),
  radius: .5em,
  text(size: .8em, body),
)

#slide[
  = `#uncover`: Reserving space
  With `#uncover`, content still occupies space, even when it is not displayed.

  For example, #uncover(2)[these words] are only visible on the second
  "subslide".

  In `()` behind `#uncover`, you specify _when_ to show the content, and in
  `[]` you then say _what_ to show:
  #example[
    ```typ
    #uncover(3)[Only visible on the third "subslide"]
    ```
    #uncover(3)[Only visible on the third "subslide"]
  ]
]

#slide[
  = Complex display rules
  So far, we only used single subslide indices to define when to show something.

  We can also use arrays of numbers...
  #example[
    ```typ
    #uncover((1, 3, 4))[Visible on subslides 1, 3, and 4]
    ```
    #uncover((1, 3, 4))[Visible on subslides 1, 3, and 4]
  ]

  ...or a dictionary with `beginning` and/or `until` keys:
  #example[
    ```typ
    #uncover((beginning: 2, until: 4))[Visible on subslides 2, 3, and 4]
    ```
    #uncover((beginning: 2, until: 4))[Visible on subslides 2, 3, and 4]
  ]
]

#slide[
  = Convenient rules as strings
  As as short hand option, you can also specify rules as strings in a special
  syntax.
  Comma separated, you can use rules of the form
  #table(
    columns: (auto, auto),
    column-gutter: 1em,
    stroke: none,
    align: (x, y) => (right, left).at(x),
    [`1-3`], [from subslide 1 to 3 (inclusive)],
    [`-4`], [all the time until subslide 4 (inclusive)],
    [`2-`], [from subslide 2 onwards],
    [`3`], [only on subslide 3],
  )
  #example[
    ```typ
    #uncover("-2, 4-6, 8-")[Visible on subslides 1, 2, 4, 5, 6, and from 8 onwards]
    ```
    #uncover("-2, 4-6, 8-")[Visible on subslides 1, 2, 4, 5, 6, and from 8 onwards]
  ]
]

#slide[
  = `#only`: Reserving no space
  Everything that works with `#uncover` also works with `#only`.

  However, content is completely gone when it is not displayed.

  For example, #only(2)[#text(red)[see how]] the rest of this sentence moves.

  Again, you can use complex string rules, if you want.
  #example[
    ```typ
    #only("2-4, 6")[Visible on subslides 2, 3, 4, and 6]
    ```
    #only("2-4, 6")[Visible on subslides 2, 3, 4, and 6]
  ]
]

#slide[
  = `#alternatives`: Substituting content
  You might be tempted to try
  #example[
    ```typ
    #only(1)[Ann] #only(2)[Bob] #only(3)[Christopher] likes #only(1)[chocolate] #only(2)[strawberry] #only(3)[vanilla] ice cream.
    ```
    #only(1)[Ann] #only(2)[Bob] #only(3)[Christopher]
    likes
    #only(1)[chocolate] #only(2)[strawberry] #only(3)[vanilla]
    ice cream.
  ]

  But it is hard to see what piece of text actually changes because everything
  moves around.
  Better:
  #example[
    ```typ
    #alternatives[Ann][Bob][Christopher] likes #alternatives[chocolate][strawberry][vanilla] ice cream.
    ```
    #alternatives[Ann][Bob][Christopher] likes #alternatives[chocolate][strawberry][vanilla] ice cream.
  ]
]

#slide[
  = `#one-by-one`: An alternative for `#show: later`
  #set text(size: .9em)
  `#alternatives` is to `#only` what `#one-by-one` is to `#uncover`.

  `#one-by-one` behaves similar to using `#show: later` but you can additionally
  state when uncovering should start.
  #example[
    ```typ
    #one-by-one(start: 2)[one ][by ][one]
    ```
    #one-by-one(start: 2)[one ][by ][one]
  ]

  `start` can also be omitted, then it starts with the first subside:
  #example[
    ```typ
    #one-by-one[one ][by ][one]
    ```
    #one-by-one[one ][by ][one]
  ]
]

#slide[
  = `#item-by-item` for lists
  Sometimes it is convenient to write the different contents to uncover one
  at a time in subsequent lines.

  This comes in especially handy for bullet lists, enumerations, and term lists.
  #example[
    #toolbox.side-by-side(
      ```typ
      #item-by-item(start: 2)[
        - first
        - second
        - third
      ]
      ```,
      item-by-item(start: 2)[
        - first
        - second
        - third
      ],
    )
  ]

  `start` is again optional and defaults to `1`.
]

#slide[
  = Reveal code

  You can use the function `#reveal-code` to slowly guide your audience through
  some code.

  #example[
    #toolbox.side-by-side[
      ````typ
      #reveal-code(lines: (1, 3))[```rs
      pub fn main() {
          let x = 42;
          let y = 6;
          dbg!(x / y);
      }
      ```]
      ````
    ][
      #reveal-code(lines: (1, 3, 5))[```rs
        pub fn main() {
            let x = 42;
            let y = 6;
            dbg!(x / y);
        }
        ```]
    ]
  ]
]

#new-section-slide[Toolbox #emoji.wrench]

#slide[
  = The `toolbox` module
  Polylux ships a `toolbox` module with solutions for common tasks in slide
  building.
]

#slide[
  = Big
  You can scale content such that it fills the remaining space using
  `#toolbox.big`:

  #toolbox.big[Wow!]
]

#slide[
  = Side by side content
  Often you want to put different content next to each other.
  We have the function `#toolbox.side-by-side` for that:

  #toolbox.side-by-side(lorem(10), lorem(20), lorem(15))
]

#slide[
  = Overview over sections
  Why not include an outline?
  #toolbox.all-sections((sections, current) => enum(tight: false, ..sections))
]

#new-section-slide("Typst features")

#slide[
  = Use Typst!
  Typst gives us so many cool things #footnote[For example footnotes!].
  Use them!
]

#slide[
  = Bibliography
  Let us cite something so we can have a bibliography: @A @B @C
  #bibliography(title: none, "literature.bib")
]

#new-section-slide("Conclusion")

#slide[
  = That's it!
  Hopefully you now have some kind of idea what you can do with this package.

  Consider giving it
  #link("https://github.com/andreasKroepelin/polylux")[
    a GitHub star #text(font: "OpenMoji")[#emoji.star]
  ]
  or open an issue if you run into bugs or have feature requests.
]
