#let config = {
  let root = sys.inputs.at("book-root", default: "")
  if root.len() > 0 and not root.starts-with("/") {
    root = "/" + root
  }
  if not root.ends-with("/") {
    root = root + "/"
  }

  (
    root: root,
    prev: sys.inputs.at("book-prev", default: ""),
    next: sys.inputs.at("book-next", default: ""),
    build: json(bytes(sys.inputs.at("book-build", default: "false"))),
  )
}

#let base-template(body, head-extra: none) = context if target() == "html" {
  let to-web-link(filename) = {
    let converted-suffix = if filename.ends-with(".typ") {
      filename.slice(0, -3) + "html"
    } else {
      filename
    }
    config.root + converted-suffix
  }

  html.html({
    html.head({
      html.meta(charset: "utf-8")
      html.meta(
        name: "viewport",
        content: "width=device-width, initial-scale=1.0",
      )
      if config.build {
        html.link(rel: "stylesheet", href: to-web-link("resources/style.css"))
        html.script(defer: true, src: to-web-link("resources/control.js"))
      } else {
        html.style(read("resources/style.css"))
      }
      head-extra
    })
    html.body({
      html.div(
        id: "outline",
        class: "hidden",
        {
          show link: it => html.a(href: to-web-link(it.dest), it.body)
          include "outline.typ"
        },
      )
      html.header({
        html.button(
          id: "outline-toggle",
          image(width: 2em, "assets/hamburger.svg"),
        )
        strong[Polylux]
        parbreak()
        link("https://typst.app/universe/package/polylux")[#sym.arrow.r Universe]
      })
      html.main({
        body
      })
      html.footer({
        if config.build and config.prev == "" {
          html.span() // empty element so that the flex layout still works
        } else {
          html.a(
            href: to-web-link(config.prev),
            image(width: 2em, "assets/left.svg"),
          )
        }
        if config.build and config.next == "" {
          html.span() // empty element so that the flex layout still works
        } else {
          html.a(
            href: to-web-link(config.next),
            image(width: 2em, "assets/right.svg"),
          )
        }
      })
      if not config.build {
        html.script(read("resources/control.js"))
      }
    })
  })
} else { body }

#let example(id: "", bgcolor: gray, columns: 1, hide-code: false, code) = {
  let code-text = code.text.replace(
    "// POLYLUX IMPORT",
    "#import \"@preview/polylux:0.4.0\": *",
  )

  if not hide-code {
    let shown-lines = ()
    let show-flag = false
    for line in code-text.split("\n") {
      if line == "// START" {
        show-flag = true
      } else if line == "// STOP" {
        show-flag = false
      } else if show-flag {
        shown-lines.push(line)
      }
    }
    raw(
      block: code.block,
      lang: code.lang,
      shown-lines.join("\n"),
    )
  }
  [#metadata((
      code: code-text,
      id: id,
      bgcolor: bgcolor,
      columns: columns,
    )) <book-example>]
  if config.build {
    // image(id + ".png")
    image(id + ".svg")
  } else {
    par[_image is not displayed in this build mode_]
  }
}
