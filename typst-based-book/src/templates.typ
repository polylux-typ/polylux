#let base-template(body, head-extra: none) = context if target() == "html" {
  let to-web-link(filename) = {
    let root = sys.inputs.at("book-root", default: "")
    let converted-suffix = if filename.ends-with(".typ") {
      filename.slice(0, -3) + "html"
    } else {
      filename
    }
    if root.len() > 0 and not root.starts-with("/") {
      root = "/" + root
    }
    if not root.ends-with("/") {
      root = root + "/"
    }
    root + converted-suffix
  }

  html.html({
    html.head({
      html.meta(charset: "utf-8")
      html.meta(
        name: "viewport",
        content: "width=device-width, initial-scale=1.0",
      )
      // html.style(read("style.css"))
      html.link(rel: "stylesheet", href: to-web-link("resources/style.css"))
      html.script(defer: true, src: to-web-link("resources/control.js"))
      head-extra
    })
    html.body({
      html.div(
        id: "outline",
        style: "display:none",
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
        let prev = sys.inputs.at("book-prev", default: "")
        let next = sys.inputs.at("book-next", default: "")
        if prev != "" {
          html.a(
            href: to-web-link(prev),
            image(width: 2em, "assets/left.svg"),
          )
        } else {
          html.span()
        }
        if next != "" {
          html.a(
            href: to-web-link(next),
            image(width: 2em, "assets/right.svg"),
          )
        } else {
          html.span()
        }
      })
      // html.script(defer: true, read("control.js"))
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
  if "book-images" in sys.inputs {
    // import "@preview/based:0.2.0": base64
    // image(base64.decode(sys.inputs.at(id)))
    image(id + ".png")
  } else {
    par[_no image available_]
  }
}
