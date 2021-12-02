import gleam/int.{sum}
import gleam/list.{fold, map, try_map, window, window_by_2}
import gleam/string.{split}

pub fn run(input) {
  assert Ok(input) =
    split(input, on: "\n")
    |> try_map(int.parse)

  #(pt_1(input), pt_2(input))
}

fn pt_1(input: List(Int)) -> Int {
  input
  |> window_by_2
  |> fold(
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
  |> window(3)
  |> map(sum)
  |> pt_1
}
