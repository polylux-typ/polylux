# Getting started

You can find this package in the
[official Typst package repository](https://github.com/typst/packages).
To use it, start your document with
```typ
{{#include ../IMPORT.typ}}
```
You now have two options:
1. Start from one of the
  [templates](https://typst.app/universe/search/?q=polylux&kind=templates).
  If you want just a minimal scaffold to get you started, try out
  [the basic template](https://github.com/polylux-typ/basic) by running
  `typst init @preview/basic-polylux:0.1.0 your-cool-project`.
2. Start from scratch.

We will choose the second option for this tutorial.
Let's start with the absolute minimal effort.
What characterises a set of slides?
Well, each slide (or PDF page, as we already established) has specific dimensions.
Some time ago, a 4:3 format was common, nowadays 16:9 is used more often.
Typst has those built in:
```typ
#set page(paper: "presentation-16-9")
```
You probably don't want your audience to carry magnifying glasses, so let's set
the font size to something readable from the last row:
```typ
#set text(size: 25pt)
```
We should be ready do go to create some actual slides now.
We will use the function `slide` for this, which is kind of at the core
of this package.
```typ
// Remember to actually import Polylux before this!
{{#include hello-world.typ:6:8}}
```
And here is the result (the gray border is not part of the output but it makes
the slide easier to see here):
![helloworld](hello-world.png)
Already kinda looks like a slide, but also a bit boring, maybe.
We should add a title slide before that so that our audience actually knows what
talk they are attending.
Also, let us choose a nicer font and maybe add some colour?
We modify the `#set page` and `#set text` commands for that:
```typ
{{#include title-slide.typ:3:18}}
```
![titleslide](title-slide.png)
Not bad, right?
Another thing that is usually a good idea is to have a title on each slide.
That is also no big deal by using off-the-shelf Typst features, so let's modify
our first slide:
```typ
{{#include slide-title.typ:15:18}}
```
This is starting to look like a real presentation:
![slidetitle](slide-title.png)

## So what?
To be honest, everything we did so far would have been just as easy without
using Polylux at all.
So why should you care about it?

Consider the following situation:
You have a slide where parts of the content appear or disappear, or the colour
of some text changes, or some other small-sized change.
Would you like to duplicate the whole slide just so to create this affect?
And then maintain multiple copies of the same content, making sure never to
forget updating all copies when your content evolves?
Of course you wouldn't and, gladly, Polylux can handle this for you.

This kind of feature is called **dynamic content** or **overlays** (loosely
speaking, you might also say **animations** but that might be a bit of a stretch,
nothing actually "moves" on PDF pages).

So how does that work in Polylux?
As a quick example, let's add a little quiz to our slides:
```typ
{{#include quiz.typ:20:27}}
```
![quiz](quiz.png)
Note how two more slides have been created even though we declared only one.

The next sections will explain dynamic content in Polylux in all its details.

For reference, here is the full source code for the slides we developed in this
section:
```typ
{{#include ../IMPORT.typ}}

{{#include quiz.typ:3:27}}
```

