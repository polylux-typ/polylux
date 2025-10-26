# Frequently Asked Questions

## Is it possible to also hide the markers of hidden list items?

Yes. You can use the following show rules:

```typ
#let no-par-spacing(it) = (
  context {
    set par(spacing: par.leading)
    it
  }
)

#show list: no-par-spacing
#show enum: no-par-spacing

#show hide: it => {
  show list.item: list
  show enum.item: enum

  it
}
```
This works by splitting up the list into multiple lists,
each with one list item.
This change hides the list marker properly,
but also increases the spacing between individual list items
(as the items are now individual lists).
The first two show rules in the snippet above fix this by reducing
the spacing between lists to be the same as the
spacing between list items within one list.
