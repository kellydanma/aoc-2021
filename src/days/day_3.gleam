import gleam/int.{parse, to_string}
import gleam/list.{fold, map, reverse, transpose, try_map}
import gleam/string.{concat, split, to_graphemes}
import gleam/io.{debug}

pub fn run(input) {
  let input =
    split(input, on: "\n")
    |> map(fn(n) {
      let bits = to_graphemes(n)
      assert Ok(int_bits) = try_map(bits, parse)
      int_bits
    })
    |> transpose

  #(pt_1(input), pt_2(input))
}

fn pt_1(input: List(List(Int))) -> Int {
  let gamma =
    input
    |> map(fn(n) {
      most_common(n)
      |> bit_to_int
    })
    |> map(to_string)
    |> concat
    |> base2_string_to_decimal

  let epsilon =
    input
    |> map(fn(n) {
      least_common(n)
      |> bit_to_int
    })
    |> map(to_string)
    |> concat
    |> base2_string_to_decimal

  gamma * epsilon
}

fn pt_2(input: List(List(Int))) -> Int {
  //todo
  1
}

fn base2_string_to_decimal(input: String) -> Int {
  let decimal_value =
    input
    |> to_graphemes
    |> reverse
    |> fold(
      #(0, 0),
      // decimal value, power
      fn(acc: #(Int, Int), bit: String) {
        assert Ok(int_bit) = parse(bit)
        #(acc.0 + exponent(2, acc.1) * int_bit, acc.1 + 1)
      },
    )

  decimal_value.0
}

fn exponent(base: Int, power: Int) -> Int {
  recursive_exponent(1, base, power)
}

fn recursive_exponent(acc: Int, base: Int, power: Int) -> Int {
  case power == 0 {
    True -> acc
    False -> recursive_exponent(acc * base, base, power - 1)
  }
}

type Bit {
  Zero
  One
}

fn bit_to_int(input: Bit) -> Int {
  case input {
    Zero -> 0
    One -> 1
  }
}

fn most_common(input: List(Int)) -> Bit {
  let zeros = count(input, Zero)
  let ones = count(input, One)

  case zeros > ones {
    True -> Zero
    False -> One
  }
}

fn least_common(input: List(Int)) -> Bit {
  let zeros = count(input, Zero)
  let ones = count(input, One)

  case zeros < ones {
    True -> Zero
    False -> One
  }
}

fn count(input: List(Int), bit: Bit) -> Int {
  let tally =
    input
    |> fold(
      #(0, 0),
      // # of zeros, # of ones
      fn(acc: #(Int, Int), bit: Int) {
        case bit {
          0 -> #(acc.0 + 1, acc.1)
          1 -> #(acc.0, acc.1 + 1)
        }
      },
    )

  case bit {
    Zero -> tally.0
    One -> tally.1
  }
}
