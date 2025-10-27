#import "../templates.typ": example, base-template

#show: base-template

#title[Dynamic slides]

The PDF format does not (trivially) allow to include animations, as one would be
used to from, say, PowerPoint.
The solution PDF-based presentation slides use is to create multiple PDF pages
for one slide, each with slightly different content.
This enables us to have some basic dynamic elements on our slides.

In this book, we will use the term _logical slide_ for a section of content that
was created by one call to `#slide`, and _subslide_ for a resulting PDF
page.
Each logical side can have an arbitrary amount of subslides and every subslide
is part of exactly one logical slide.
Note that the same page number is displayed for all subslides of a logical slide.

As you will see soon, the commands for creating dynamic content all have some way
of specifying on what subslides some content is supposed to be shown.
One of those subslides has the highest index, of course.
*Of all those commands with their respective highest subslide to show something,
the maximum is take again and that defines the number of PDF pages produced for
one logical slide.*
For example, suppose we have a slide with the following commands:
- show something on subslides 1 and 3
- show something from subslide 2 to subslide 4
- show something until subslide 6

This results in 6 PDF pages for this logical slide.


In the LaTeX beamer package, the functionalities described in this part are
called "overlays".

