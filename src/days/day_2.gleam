import gleam/int.{parse, sum}
import gleam/list.{fold, map, try_map, window, window_by_2}
import gleam/string.{split}
import gleam/io.{debug}

pub fn run(input) {
  let input =
    split(input, on: "\n")
    |> map(fn(n) {
      let [direction, displacement] = split(n, on: " ")
      assert Ok(i) = parse(displacement)
      #(direction, i)
    })

  #(pt_1(input), pt_2(input))
}

fn pt_1(input: List(#(String, Int))) -> Int {
  horizontal_displacement(input) * vertical_displacement(input)
}

fn pt_2(input: List(#(String, Int))) -> Int {
  aim(input)
}

fn horizontal_displacement(input: List(#(String, Int))) -> Int {
  input
  |> fold(
    0,
    fn(acc, instruction: #(String, Int)) {
      acc + case instruction.0 {
        "forward" -> instruction.1
        "down" -> 0
        "up" -> 0
      }
    },
  )
}

fn vertical_displacement(input: List(#(String, Int))) -> Int {
  input
  |> fold(
    0,
    fn(acc, instruction: #(String, Int)) {
      acc + case instruction.0 {
        "down" -> instruction.1
        "up" -> -1 * instruction.1
        "forward" -> 0
      }
    },
  )
}

fn aim(input: List(#(String, Int))) -> Int {
  let result =
    input
    |> fold(
      #(0, 0, 0),
      // horizontal, depth, aim
      fn(acc: #(Int, Int, Int), instruction: #(String, Int)) {
        case instruction.0 {
          "down" -> #(acc.0, acc.1, acc.2 + instruction.1)
          "up" -> #(acc.0, acc.1, acc.2 - instruction.1)
          "forward" -> #(
            acc.0 + instruction.1,
            acc.1 + acc.2 * instruction.1,
            acc.2,
          )
        }
      },
    )

  result.0 * result.1
}
