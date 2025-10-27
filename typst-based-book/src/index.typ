#import "templates.typ": example, base-template

#show: base-template

#title[Polylux]

*Polylux* is a package for the typesetting system
#link("https://typst.app")[Typst] to create presentation slides, just like you
would use the _beamer_ package in LaTeX.
(So far, it is much less advanced than beamer, obviously.)

If you haven't heard of things like LaTeX's beamer before, here is how this
works:
As a rule of thumb, one slide becomes one PDF page, and most PDF viewers can
display PDFs in the form of a slide show (usually by hitting the F5-key).


Polylux gives you:
- Elegant yet powerful typesetting by the ever-improving Typst.
- Fully customisable slides.
- Dynamic slides (or *overlays* or (dis-)appearing content, or however you want
  to call it).
- Some
  #link("https://typst.app/universe/search/?q=polylux&kind=templates")[templates]
  to get you up to speed quickly.

If you like it, consider
#link("https://github.com/andreasKroepelin/polylux")[giving a star on GitHub]!


= Why the name?
A #link("https://en.wikipedia.org/wiki/Polylux_(overhead_projector)")[_polylux_]
is a brand of overhead projectors very common in Eastern German schools (where
the main author of this package grew up).
It fulfils a similar function to a projector, namely projecting visuals to a
wall to aid a presentation.
The German term for projector is _beamer_, and now you might understand how it
all comes together.
(The original author of the aforementioned LaTeX package is German as well.)

= About this book
This book documents all features currently implemented in Polylux.
Specifically, it describes the state of the package as it is pulished to the
Typst package registry.
The `main` branch of the Polylux repository may contain features not documented
here.

= Contributing
This package is free and open source.
You can find the code on
#link("https://github.com/andreasKroepelin/polylux")[GitHub]
where you can also create issues or pull requests.

= License
Polylux is released under the
#link("https://github.com/andreasKroepelin/polylux/blob/main/LICENSE")[MIT license].

