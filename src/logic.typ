#let subslide = counter("subslide")
#let later-counter = counter("later-counter")
#let logical-slide = counter("logical-slide")
#let repetitions = counter("repetitions")
#let handout-mode = state("handout-mode", false)

#let enable-handout-mode(flag) = handout-mode.update(flag)

#let _slides-cover(mode, body) = {
  if mode == hide {
    hide(body)
  } else if type(mode) == color {
    text(fill: mode, body)
  } else {
    panic("Illegal cover mode: " + mode)
  }
}

#let _parse-subslide-indices(s) = {
  let parts = s.split(",").map(p => p.trim())
  let parse-part(part) = {
    let match-until = part.match(regex("^-([[:digit:]]+)$"))
    let match-beginning = part.match(regex("^([[:digit:]]+)-$"))
    let match-range = part.match(regex("^([[:digit:]]+)-([[:digit:]]+)$"))
    let match-single = part.match(regex("^([[:digit:]]+)$"))
    if match-until != none {
      let parsed = int(match-until.captures.first())
      // assert(parsed > 0, "parsed idx is non-positive")
      (until: parsed)
    } else if match-beginning != none {
      let parsed = int(match-beginning.captures.first())
      // assert(parsed > 0, "parsed idx is non-positive")
      (beginning: parsed)
    } else if match-range != none {
      let parsed-first = int(match-range.captures.first())
      let parsed-last = int(match-range.captures.last())
      // assert(parsed-first > 0, "parsed idx is non-positive")
      // assert(parsed-last > 0, "parsed idx is non-positive")
      (beginning: parsed-first, until: parsed-last)
    } else if match-single != none {
      let parsed = int(match-single.captures.first())
      // assert(parsed > 0, "parsed idx is non-positive")
      parsed
    } else {
      panic("failed to parse visible slide idx:" + part)
    }
  }
  parts.map(parse-part)
}

#let _check-visible(idx, visible-subslides) = {
  if type(visible-subslides) == int {
    idx == visible-subslides
  } else if type(visible-subslides) == array {
    visible-subslides.any(s => _check-visible(idx, s))
  } else if type(visible-subslides) == str {
    let parts = _parse-subslide-indices(visible-subslides)
    _check-visible(idx, parts)
  } else if type(visible-subslides) == dictionary {
    let lower-okay = if "beginning" in visible-subslides {
      visible-subslides.beginning <= idx
    } else {
      true
    }

    let upper-okay = if "until" in visible-subslides {
      visible-subslides.until >= idx
    } else {
      true
    }

    lower-okay and upper-okay
  } else {
    panic("you may only provide a single integer, an array of integers, or a string")
  }
}

#let _last-required-subslide(visible-subslides) = {
  if type(visible-subslides) == int {
    visible-subslides
  } else if type(visible-subslides) == array {
    calc.max(..visible-subslides.map(s => _last-required-subslide(s)))
  } else if type(visible-subslides) == str {
    let parts = _parse-subslide-indices(visible-subslides)
    _last-required-subslide(parts)
  } else if type(visible-subslides) == dictionary {
    let last = 0
    if "beginning" in visible-subslides {
      last = calc.max(last, visible-subslides.beginning)
    }
    if "until" in visible-subslides {
      last = calc.max(last, visible-subslides.until)
    }
    last
  } else {
    panic("you may only provide a single integer, an array of integers, or a string")
  }
}

#let _conditional-display(visible-subslides, reserve-space, mode, body) = {
  context {
    let vs = if reserve-space and handout-mode.at(here()) {
      (:)
    } else {
      visible-subslides
    }
    repetitions.update(rep => calc.max(rep, _last-required-subslide(vs)))
    if _check-visible(subslide.at(here()).first(), vs) {
      body
    } else if reserve-space {
      _slides-cover(mode, body)
    }
  }
}

#let uncover(visible-subslides, mode: hide, body) = {
  _conditional-display(visible-subslides, true, mode, body)
}

#let only(visible-subslides, body) = {
  _conditional-display(visible-subslides, false, "doesn't even matter", body)
}

#let one-by-one(start: 1, mode: hide, ..children) = {
  for (idx, child) in children.pos().enumerate() {
    uncover((beginning: start + idx), mode: mode, child)
  }
}

#let item-by-item(start: 1, mode: hide, body) = {
  let is-item(it) = (
    type(it) == content
      and it.func()
        in (
          list.item,
          enum.item,
          terms.item,
        )
  )
  let children = if type(body) == content and body.has("children") {
    body.children
  } else {
    body
  }
  one-by-one(start: start, mode: mode, ..children.filter(is-item))
}

#let alternatives-match(subslides-contents, position: bottom + left) = {
  let subslides-contents = if type(subslides-contents) == dictionary {
    subslides-contents.pairs()
  } else {
    subslides-contents
  }

  let subslides = subslides-contents.map(it => it.first())
  let contents = subslides-contents.map(it => it.last())
  context {
    let sizes = contents.map(c => measure(c))
    let max-width = calc.max(..sizes.map(sz => sz.width))
    let max-height = calc.max(..sizes.map(sz => sz.height))
    for (subslides, content) in subslides-contents {
      only(
        subslides,
        box(
          width: max-width,
          height: max-height,
          align(position, content),
        ),
      )
    }
  }
}

#let alternatives(
  start: 1,
  repeat-last: false,
  ..args,
) = {
  let contents = args.pos()
  let kwargs = args.named()
  let subslides = range(start, start + contents.len())
  if repeat-last {
    subslides.last() = (beginning: subslides.last())
  }
  alternatives-match(subslides.zip(contents), ..kwargs)
}

#let alternatives-fn(
  start: 1,
  end: none,
  count: none,
  ..kwargs,
  fn,
) = {
  let end = if end == none {
    if count == none {
      panic("You must specify either end or count.")
    } else {
      start + count
    }
  } else {
    end
  }

  let subslides = range(start, end)
  let contents = subslides.map(fn)
  alternatives-match(subslides.zip(contents), ..kwargs.named())
}

#let alternatives-cases(cases, fn, ..kwargs) = {
  let idcs = range(cases.len())
  let contents = idcs.map(fn)
  alternatives-match(cases.zip(contents), ..kwargs.named())
}

#let reveal-code(
  start: 1,
  lines: (),
  before: gray,
  after: hide,
  full: true,
  body,
) = {
  lines.insert(0, 0)
  let (before-action, after-action) = (before, after).map(c => {
    if type(c) == color {
      it => text(fill: c, it.text)
    } else if c == hide {
      hide
    } else {
      panic("Illegal mode: " + str(c))
    }
  })
  for (idx, (from, to)) in lines.windows(2).enumerate() {
    show raw.line: it => {
      if it.number <= from {
        before-action(it)
      } else if it.number > to {
        after-action(it)
      } else {
        it
      }
    }
    only(start + idx, body)
  }
  if full {
    only((beginning: start + lines.len() - 1), body)
  }
}

#let later(body, strand: 1, mode: hide) = {
  context if handout-mode.get() {
    body
  } else {
    later-counter.step(level: strand)
    context {
      let curr-lc = later-counter.get().at(strand - 1)
      repetitions.update(r => calc.max(r, curr-lc + 1))
      if curr-lc < subslide.get().first() {
        body
      } else {
        _slides-cover(mode, body)
      }
    }
  }
}

#let slide(body) = {
  context {
    if logical-slide.get().first() > 0 {
      pagebreak(weak: true)
    }
  }
  logical-slide.step()
  subslide.update(1)
  repetitions.update(1)
  later-counter.update(0)

  // Having this here is a bit unfortunate concerning separation of concerns
  // but I'm not comfortable with logic depending on pdfpc...
  let pdfpc-slide-markers(curr-subslide) = context [
    #metadata((t: "NewSlide")) <pdfpc>
    #metadata((t: "Idx", v: counter(page).get().first() - 1)) <pdfpc>
    #metadata((t: "Overlay", v: curr-subslide - 1)) <pdfpc>
    #metadata((t: "LogicalSlide", v: logical-slide.get().first())) <pdfpc>
  ]

  pdfpc-slide-markers(1)

  body

  subslide.step()
  set heading(outlined: false)

  context {
    let reps = repetitions.get().first()
    for curr-subslide in range(2, reps + 1) {
      later-counter.update(0)
      pagebreak(weak: true)

      pdfpc-slide-markers(curr-subslide)

      body
      subslide.step()
    }
  }
}
