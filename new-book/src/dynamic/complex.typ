#import "../setup.typ": example, toot-page
#set document(title: [Complex display rules])
#show: toot-page

#title()
There are multiple options to define more complex display rules than a single
number.

= Array
The simplest extension is to use an array.
For example:
#example(
  columns: 2,
  ```typ
  // SETUP
  // START
  #slide[
    #uncover((1, 2, 4))[uncovered only on subslides 1, 2, and 4]
  ]
  ```,
)

The array elements can actually themselves be any kind of rule that is explained
on this page.

= Interval
You can also provide a (bounded or half-bounded) interval in the form of a
dictionary with a `beginning` and/or an `until` key:
#example(
  columns: 3,
  ```typ
  // SETUP
  // START
  #slide[
    #only((beginning: 1, until: 5))[Content displayed on subslides 1, 2, 3, 4, and 5 \ ]
    #only((beginning: 2))[Content displayed on subslide 2 and every following one \ ]
    #only((until: 3))[Content displayed on subslides 1, 2, and 3 \ ]
    #only((:))[Content that is always displayed]
  ]
  ```,
)

In the last case, you would not need to use `#only` anyways, obviously.

= Convenient syntax as strings
In principle, you can specify every rule using numbers, arrays, and intervals.
However, consider having to write
```typ
#uncover(((until: 2), 4, (beginning: 6, until: 8), (beginning: 10)))[Polylux]
```
That's only fun the first time.
Therefore, we provide a convenient alternative.
You can equivalently write:
#example(
  columns: 4,
  ```typ
  // SETUP
  #set text(size: 40pt)

  #slide[
  // START
  #uncover("-2, 4, 6-8, 10-")[Polylux]
  // STOP
  ]
  ```,
)

Much better, right?
The spaces are optional, so just use them if you find it more readable.

Unless you are creating those function calls programmaticly, it is a good
recommendation to use the single-number syntax (`#only(1)[...]`) if that
suffices and the string syntax for any more complex use case.


