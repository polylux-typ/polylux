#let speaker-note(text) = {
  let text = if type(text) == str {
    text
  } else if type(text) == content and text.func() == raw {
    text.text.trim()
  } else {
    panic("A note must either be a string or a raw block")
  }
  [ #metadata((t: "Note", v: text)) <pdfpc> ]
}

#let end-slide = [
  #metadata((t: "EndSlide")) <pdfpc>
]

#let save-slide = [
  #metadata((t: "SaveSlide")) <pdfpc>
]

#let hidden-slide = [
  #metadata((t: "HiddenSlide")) <pdfpc>
]

#let config(
  duration-minutes: none,
  start-time: none,
  end-time: none,
  last-minutes: none,
  note-font-size: none,
  disable-markdown: false,
  default-transition: none,
) = {
  if duration-minutes != none {
    [ #metadata((t: "Duration", v: duration-minutes)) <pdfpc> ]
  }

  let _time-config(time, msg-name, tag-name) = {
    let time = if type(time) == "datetime" {
      time.display("[hour padding:zero repr:24]:[minute padding:zero]")
    } else if type(time) == "string" {
      time
    } else {
      panic(msg-name + " must be either a datetime or a string in the HH:MM format.")
    }

    [ #metadata((t: tag-name, v: time)) <pdfpc> ]
  }

  if start-time != none {
    _time-config(start-time, "Start time", "StartTime")
  }

  if end-time != none {
    _time-config(end-time, "End time", "EndTime")
  }

  if last-minutes != none {
    [ #metadata((t: "LastMinutes", v: last-minutes)) <pdfpc> ]
  }

  if note-font-size != none {
    [ #metadata((t: "NoteFontSize", v: note-font-size)) <pdfpc> ]
  }

  [ #metadata((t: "DisableMarkdown", v: disable-markdown)) <pdfpc> ]

  if default-transition != none {
    let dir-to-angle(dir) = if dir == ltr {
      "0"
    } else if dir == rtl {
      "180"
    } else if dir == ttb {
      "90"
    } else if dir == btt {
      "270"
    } else {
      panic("angle must be a direction (ltr, rtl, ttb, or btt)")
    }

    let transition-str = (
      default-transition.at("type", default: "replace")
      + ":" +
      str(default-transition.at("duration-seconds", default: 1))
      + ":" +
      dir-to-angle(default-transition.at("angle", default: rtl))
      + ":" +
      default-transition.at("alignment", default: "horizontal")
      + ":" +
      default-transition.at("direction", default: "outward")
    )

    [ #metadata((t: "DefaultTransition", v: transition-str)) <pdfpc> ]
  }
}
