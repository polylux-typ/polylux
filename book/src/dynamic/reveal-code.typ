#import "../../../src/polylux.typ": *
#set page(paper: "presentation-16-9")
#set text(size: 35pt, font: "Atkinson Hyperlegible")

#slide[
  #reveal-code(lines: (1, 3, 6, 7))[```rust
    pub fn main() {
      let x = vec![3, 4, 1];
      let y = &x;
      if let Some(a) = x.first() {
        dbg!(a);
      } else {
        println!("x is empty.");
      }
    }
    ```]
]
