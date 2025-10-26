# More sophisticated piecewise revealing
## `#one-by-one`
`#pause` may be considered syntactically a bit cumbersome as it employs a
`show`-rule.
If you prefer to signal the grouping of content appearing together by using
a single function call, you can use `#one-by-one`:
```typ
{{#include one-by-one.typ:6}}
```
resulting in

![one-by-one](one-by-one.png)

If we still want to uncover certain elements one after the other but starting
on a later subslide, we can use the optional `start` argument of `#one-by-one`:
```typ
{{#include one-by-one-start.typ:6}}
```
resulting in

![one-by-one-start](one-by-one-start.png)

This optional `start` argument exists for all functions displayed on this page.


## `#item-by-item`
`#one-by-one` is especially useful for arbitrary contents that you want to display
in that manner.
Sometimes, it produces a bit too much syntactical noise with all the brackets
between content, though.
That is especially true for lists, enums, and term lists.
Instead of
```typ
#one-by-one[
  - first
][
  - second
][
  - third
]
```
you can also write
```typ
{{#include item-by-item.typ:6:10}}
```
resulting in

![item-by-item](item-by-item.png)

A more complex example involving enums and term lists:
```typ
{{#include item-by-item-complex.typ:6:28}}
```

![item-by-item-complex](item-by-item-complex.png)

Note that the list markers and enum numbers are not hidden.
You can truly consider this a bug or a feature...

This is due to a [bug](https://github.com/typst/typst/issues/619) in typst.
See the
[FAQ](../faq/faq.md#is-it-possible-to-also-hide-the-markers-of-hidden-list-items)
for a workaround.
