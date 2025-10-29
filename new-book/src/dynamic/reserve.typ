#import "../setup.typ": example, toot-page
#set document(title: [Reserve space or not?])
#show: toot-page

#title()

When you want to specify that a certain piece of content should be displayed on
some subslides but not on others, the first question should be what should
happen on the subslides it is _not_ displayed on.
You could either want
- that it is completely not existing there, or
- that it is invisible but it still occupies the space it would need otherwise
  (see #link("https://typst.app/docs/reference/layout/hide/")[the docs of the
  `#hide` function])

The two different behaviours can be achieved using either `#only` or `#uncover`,
respectively.
The intuition behind it is that, in one case, content is _only_ existing on some
slides, and, in the other case, it is merely _covered_ when not displayed.


