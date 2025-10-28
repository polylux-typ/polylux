#let book-toml = toml("book.toml")

#let config = {
  let root = sys.inputs.at("book-root", default: "")
  if root.len() > 0 and not root.starts-with("/") {
    root = "/" + root
  }
  if not root.ends-with("/") {
    root = root + "/"
  }

  let style = book-toml.at("style", default: (:))
  let snippets = book-toml.at("snippets", default: ())
  assert(
    snippets
      .filter(s => (
        type(s) != dictionary or "trigger" not in s or "expansion" not in s
      ))
      .len()
      == 0,
  )

  (
    root: root,
    prev: sys.inputs.at("book-prev", default: ""),
    next: sys.inputs.at("book-next", default: ""),
    page-id: sys.inputs.at("book-page-id", default: ""),
    build: json(bytes(sys.inputs.at("book-build", default: "false"))),
    accent-color: style.at("accent-color", default: "gray"),
    snippets: snippets,
  )
}

#let to-web-link(filename) = {
  let converted-suffix = if filename.ends-with(".typ") {
    filename.slice(0, -3) + "html"
  } else {
    filename
  }
  config.root + converted-suffix
}

#let base-template(body, head-extra: none) = context if target() == "html" {
  html.html({
    html.head({
      html.meta(charset: "utf-8")
      html.meta(
        name: "viewport",
        content: "width=device-width, initial-scale=1.0",
      )
      html.style(":root { --accent-color: " + config.accent-color + "; } ")
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

#let example-counter = counter("book-example")

#let example(
  bgcolor: gray,
  columns: 1,
  hide-code: false,
  code,
) = context {
  let code-text = code.text
  for snippet in config.snippets {
    code-text = code-text.replace(snippet.trigger, snippet.expansion)
  }

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
  let example-id = "example" + str(example-counter.get().first())
  example-counter.step()
  [#metadata((
      code: code-text,
      id: example-id,
      bgcolor: bgcolor,
      columns: columns,
    )) <book-example>]
  if config.build {
    html.picture({
      for theme in ("light", "dark") {
        html.source(
          media: "(prefers-color-scheme: " + theme + ")",
          srcset: (
            (
              src: to-web-link(
                config.page-id + "-" + example-id + "-" + theme + ".svg",
              ),
            ),
          ),
        )
      }
      html.img(
        alt: config.page-id + "-" + example-id,
        src: to-web-link(config.page-id + "-" + example-id + "-light" + ".svg"),
      )
    })
  } else {
    par[_image is not displayed in this build mode_]
  }
}
