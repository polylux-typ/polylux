#import "../logic.typ"

#import "pdfpc.typ"

// SECTIONS

#let sections-state = state("polylux-sections", ())
#let register-section(name) = context {
  let loc = here()
  sections-state.update(sections => {
    sections.push(link(loc, name))
    sections
  })
}

#let _contextual-current-section() = {
  let sections = sections-state.get()
  if sections.len() > 0 {
    sections.last()
  } else {
    []
  }
}

#let current-section = context _contextual-current-section()

#let all-sections(fn) = context {
  let sections = sections-state.final()
  let current = _contextual-current-section()
  fn(sections, current)
}

// PROGRESS

#let progress-ratio(ratio-to-content) = context {
  let ratio = (
    logic.logical-slide.get().first() / logic.logical-slide.final().first()
  )
  ratio-to-content(ratio)
}

#let last-slide-number = context { logic.logical-slide.final().first() }

#let slide-number = context { logic.logical-slide.display() }


// HEIGHT FITTING

#let big(body) = {
  block(
    height: 1fr,
    width: 100%,
    {
      layout(sz => {
        let (width, height) = sz
        set text(top-edge: "bounds", bottom-edge: "bounds")
        scale(body, x: width, y: height, reflow: true)
      })
    },
  )
}

// SIDE BY SIDE

#let side-by-side(columns: none, gutter: 1em, ..bodies) = {
  let bodies = bodies.pos()
  let columns = if columns == none { (1fr,) * bodies.len() } else { columns }
  if columns.len() != bodies.len() {
    panic("number of columns must match number of content arguments")
  }

  grid(columns: columns, gutter: gutter, ..bodies)
}

// FULL WIDTH

#let full-width-block(..args) = context {
  let pm = page.margin
  let margin = if type(pm) in (length, relative) {
    (left: pm, right: pm)
  } else if type(pm) == dictionary {
    let left = if "left" in pm {
      pm.left
    } else if "rest" in pm {
      pm.rest
    }
    let right = if "right" in pm {
      pm.right
    } else if "rest" in pm {
      pm.rest
    }
    if none in (left, right) or auto in (left, right) {
      panic("left and right margin must be specified and not be auto")
    }
    (left: left, right: right)
  }
  let margin-x = margin.left + margin.right
  show: move.with(dx: -margin.left)
  block(width: 100% + margin-x, ..args)
}

#let next-heading(level: 1, fn) = context {
  let hs = query(heading.where(level: level).after(here()))
  if hs.len() > 0 {
    let h = hs.first()
    if h.location().page() == here().page() {
      fn(h.body)
    }
  }
}

