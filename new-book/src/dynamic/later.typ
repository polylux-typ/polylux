#import "../setup.typ": example, toot-page
#set document(title: [show later])
#show: toot-page

#title[`#show: later` to reveal content piece by piece]

Consider some code like the following:
```typ
#uncover("1-")[first]
#uncover("2-")[second]
#uncover("3-")[third]
```
The goal here is to uncover parts of the slide one by one, so that an increasing
amount of content is shown, but we don't want to specify all subslide indices
manually, ideally.

If you have used the LaTeX beamer package before, you might be familiar with the
`\pause` command.
It makes everything after it on that slide appear on the next subslide.
Features of the kind "everything after this" are handled in Typst using `#show:`
rules.
Namely, `#show: some-function` uses the following content as an argument to
`some-function`.
Polylux provides the `later` function that makes its argument appear on the
next subslide.
So, we can equivalently write the above code as:
#example(
  columns: 3,
  ```typ
  // SETUP
  #set text(size: 50pt)

  #slide[
  // START
  first
  #show: later
  second
  #show: later
  third
  // STOP
  ]
  ```,
)

`#show: later` should mainly be used when you want to distribute a lot of code
onto different subslides.
For smaller pieces of code, consider one of the functions described next.

= Multiple scopes

Note that, like every `show`-rule, `#show: later` only affects the rest of its
surrounding scope.
For other (potentially conceptually later) content in a different scope, you
have to use a new `#show: later` rule.
If you see weird interactions between different scopes using `#show: later`
or you get a warning from Typst that layouting did not converge, you can make
use of the optional argument `strand` (set to `1` by default):
```typ
#[
  this is scope 1
  #show: later
  still scope 1
]
#[
  this is scope 2
  #show: later.with(strand: 2)
  still scope 2
]
```
Every strand works independently of every other.

