# pdfpc

[pdfpc](https://pdfpc.github.io/) is a "presenter console with multi-monitor
support for PDF-files".
That means, you can use it to display slides in the form of PDF-pages and also
have some of the nice features known from, for example, PowerPoint.
Check out their website to learn more.

When pdfpc is provided a special `.pdfpc` file containing some JSON data, it can
use that to enhance the user experience by correctly handling overlay slides,
displaying speaker notes, setting up a specific timer, and more.
While you can write this file by hand or use the pdfpc-internal features to edit
it, some might find it more convenient to have all data about their presentation
in one place, i.e. the Typst source file.
Polylux allows you to do that.

## Adding metadata to the Typst source

Polylux exports the `pdfpc` module that comes with a bunch of useful functions
that do not actually add any content to the produced PDF but instead insert
metadata that can later be extracted from the document.

### Speaker notes
This is possibly the most useful feature of pdfpc.
Using the function `#toolbox.pdfpc.speaker-note` inside a slide, you can add a note to
that slide that will only be visible to the speaker in pdfpc.
It accepts either a string:
```typ
#toolbox.pdfpc.speaker-note("This is a note that only the speaker will see.")
```
or a `raw` block:
````typ
#toolbox.pdfpc.speaker-note(
  ```md
  # My notes
  Did you know that pdfpc supports Markdown notes? _So cool!_
  ```
)
````
Note that you can only specify one note per slide (only the first one will
survive if you use more than one.)

### End slide
Sometimes the last slide in your presentation is not really the one you want to
end with.
Say, you have some bibliography or appendix for the sake of completeness after
your "I thank my mom and everyone who believed in me"-slide.

With a simple `#toolbox.pdfpc.end-slide` inside any slide you can tell pdfpc that this is
the last slide you usually want to show and hitting the `End` key will jump there.

### Save a slide
Similarly, there is a feature in pdfpc to bookmark a specific slide (and you can
jump to it using `Shift + M`).
In your Typst source, you can choose that slide by putting `#toolbox.pdfpc.save-slide`
inside it.

### Hide slides
If you want to keep a certain slide in your presentation (just in case) but don't
normally intend to show it, you can hide it inside pdfpc.
It will be skipped during the presentation but it is still available in the
overview.
You can use `#toolbox.pdfpc.hidden-slide` in your Typst source to mark a slide as hidden.

### Configure pdfpc
The previous commands are all supposed to be used _inside_ a slide.
To perform some additional global configuration, you can use `toolbox.pdfpc.config()`
_before_ any of the slides (it will not be recognised otherwise).

It accepts the following optional keyword arguments:

- `duration-minutes`: how many minutes (a number) the presentation is supposed
  to take, affects the timer in pdfpc
- `start-time`: wall-clock time when the presentation is supposed to start, either
  as a `datetime(hour: ..., minute: ..., second: ...)` or as a string in the
  `HH:MM` format
- `end-time`: same as `start-time` but when the presentation is supposed to end
- `last-minutes`: how many minutes (a number) before the time runs out the timer
  is supposed to change its colour as a warning
- `note-font-size`: the font size (a number) the speaker notes are displayed in
- `disable-markdown`: whether or not to disable rendering the notes as markdown
  (a bool), default `false`
- `default-transition`: the transition to use between subsequent slides, must be
  given as a dictionary with (potentially) the following keys:
    - `type`: one of `"replace"` (default), `"push"`, `"blinds"`, `"box"`,
      `"cover"`, `"dissolve"`, `"fade"`, `"glitter"`, `"split"`, `"uncover"`,
      `"wipe"`
    - `duration-seconds`: the duration of the transition in seconds (a number)
    - `angle`: in which angle the transition moves, one of `ltr`, `rtl`, `ttb`,
      and `btt` (see [the `#stack` function](https://typst.app/docs/reference/layout/stack/#parameters-dir))
    - `alignment`: whether the transition is performed horizontally or vertically,
      one of `"horizontal"` and `"vertical"`
    - `direction`: whether the transition is performed inward or outward, one of
      `"inward"` and `"outward"`

  Not all combinations of values are necessary or make sense for all transitions,
  of course.

## Extracting the data:  `polylux2pdfpc`
As mentioned above, the functions from the `pdfpc` module don't alter the produced
PDF itself.
Instead, we need some other way to extract their data.
You could, in principle, do that by hand using the `typst query` CLI and then
assemble the correct `.pdfpc` file yourself.
However, this tedious task is better solved by the `polylux2pdfpc` tool.

### Installation
If you have [Rust](https://www.rust-lang.org/tools/install) installed, you can
simply run
```sh
cargo install --git https://github.com/andreasKroepelin/polylux/ --branch release
```
If you use Arch Linux btw, you can also install `polylux2pdfpc` from the AUR
package [polylux2pdfpc-git](https://aur.archlinux.org/packages/polylux2pdfpc-git)
(thank you to Julius Freudenberger!)

### Usage
You invoke `polylux2pdfpc` with the same arguments you would also give to `typst
compile` when you wanted to build your slides.
For example, say you have a file called `talk.typ` in the folder `thesis` that
has some global utility files or so, you
would compile it using
```sh
typst compile --root .. thesis/talk.typ
```
and extract the pdfpc data using
```sh
polylux2pdfpc --root .. thesis/talk.typ
```

Internally, `polylux2pdfpc` runs `typst query`, collects all the pdfpc-related
metadata and then writes a `.pdfpc` file that equals the input file up to the
suffix.
In our example with `thesis/talk.typ`, we obtain `thesis/talk.pdfpc`.
Since `typst compile` produced `thesis/talk.pdf`, you can now simply open the PDF
in pdpfc:
```sh
pdfpc thesis/talk.pdf
```
and it will automatically recognise the `.pdfpc` file.
