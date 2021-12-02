import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn run(input) {
  assert Ok(input) =
    string.split(input, on: "\n")
    |> list.try_map(int.parse)

  #(pt_1(input), pt_2(input))
}

fn pt_1(input: List(Int)) -> Int {
  input
  |> list.window_by_2
  |> list.fold(
    0,
    fn(acc, pair: #(Int, Int)) {
      acc + case pair.1 - pair.0 > 0 {
        True -> 1
        False -> 0
      }
    },
  )
}

fn pt_2(input: List(Int)) -> Int {
  input
  |> list.window(3)
  |> list.map(list.fold(_, 0, fn(x, y) { x + y }))
  |> pt_1
}
