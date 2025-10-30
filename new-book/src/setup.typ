#import "@preview/toot:0.1.0": setup-toot

#let (toot-page, example, i-link) = setup-toot(
  name: [Polylux],
  universe-url: "https://typst.app/universe/package/polylux",
  outline: include "OUTLINE.typ",
  styling: (accent-color: blue),
  root: "polylux-toot",
  snippets: (
    (
      trigger: "// SETUP",
      expansion: ```typ
      // POLYLUX IMPORT
      // LIGHT DARK
      #set page(paper: "presentation-16-9")
      #set text(font: "Atkinson Hyperlegible Next", size: 30pt)
      ```.text,
    ),
    (
      trigger: "// POLYLUX IMPORT",
      expansion: ```typ
      #import "@preview/polylux:0.4.0": *
      ```.text,
    ),
    (
      trigger: "// LIGHT DARK",
      expansion: ```typ
      #show: body => {
        let theme = if sys.inputs.at("theme", default: "light") == "light" {
          (bg: white, fg: black)
        } else {
          (bg: luma(50), fg: white)
        }
        set page(fill: theme.bg)
        set text(fill: theme.fg)

        body
      }
      ```.text,
    ),
  ),
)
