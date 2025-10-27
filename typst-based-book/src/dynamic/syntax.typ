#import "../templates.typ": example, base-template

#show: base-template

#title[General syntax for `#only` and `#uncover`]

Both functions are used in the same way.
They each take two positional arguments, the first is a description of the
subslides the content is supposed to be shown on, the second is the content
itself.
Note that Typst provides some syntactic sugar for trailing content arguments,
namely putting the content block _behind_ the function call.

You could therefore write:
#example(
  id: "only-uncover",
  columns: 2,
  ```typ
  // POLYLUX IMPORT
  #set page(paper: "presentation-16-9")
  #set text(size: 30pt, font: "Atkinson Hyperlegible")

  // START
  #slide[
    before #only(2)[*displayed only on subslide 2*] after

    before #uncover(2)[*uncovered only on subslide 2*] after
  ]
  ```,
)

You can clearly see the difference in behaviour between `only` and `uncover`.
In the first line, "after" moves but not in the second line.

In this example, we specified only a single subslide index, resulting in content
that is shown on that exact subslide and at no other one.
Let's explore more complex rules next.

