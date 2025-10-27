# A book for Polylux, written in Typst

This is a work in progress experiment about how we could write the Polylux book
entirely in Typst.
Note how the directory `src` is much more clean than in the current book.

## Usage

For each page in the book, write a Typst file somewhere inside the `src` folder.
It should generally start with
```typ
#import "templates.typ": example, base-template

#show: base-template
```
where you might have to adapt the path of `templates.typ`.
You can add examples using the `#example` function like this:
````typ
#example(
  id: "hello-world",
  columns: 2, // default: 1
  ```typ
  // POLYLUX IMPORT

  #set page(paper: "presentation-16-9")
  #set text(size: 25pt)

  // START
  #slide[
    Hello, world!
  ]
  // STOP

  #slide[
    This slide is shown in the image but this code is not shown.
  ]
  ```,
)
````
This results in the example code between `// START` and `// STOP` inserted into
the book, as well as a rendered PNG showing the result of the whole code.
You can use `// START` and `// STOP` multiple times.
`// POLYLUX IMPORT` will get replaced by an appropriate import directive for
Polylux.

Otherwise, you just write ordinary Typst and as long as it is supported for
HTML export it should just work.

Note the special file `outline.typ` inside `src`.
Its content is displayed when the user clicks on the hamburger menu at the top
left.
It _also_ serves as the defining set and order of pages for the book, similar to
the `SUMMARY.md` file in mdbook.
Therefore, you have to include every page you want to be shown in the book as
a `#link` in `outline.typ`.

Finally, everything is put together by the `book-builder` CLI tool.
Its Julia code resides in the `BookBuilder` directory and (after having Julia
1.12 or higher installed) you install it by typing the following into the Julia
REPL:
```julia
julia> ]

(@v1.12) pgk> app dev BookBuilder
```
Afterwards, you can run the tool simply with
```sh
book-builder
```
in your shell (from the directory where this readme is located).
It will scan the `outline.typ` file and then compile all pages with all their
examples into a collection of HTML files.
The result will be put into the `build` directory.

To publish the created pages somewhere that is not a root domain
(`foo.org/book/` instead of `foo.org/`), you can specify this path by setting
the `root` argument:
```sh
book-builder root=book
```

To minimize the size of the rendered images, `book-builder` also calls `oxipng`.
If you don't have it installed or you want to skip this step, run
```sh
book-builder optimize=false
```

