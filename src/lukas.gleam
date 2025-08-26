import argv
import gleam/erlang/process
import gleam/io
import gleam/list

pub fn main() {
  case argv.load().arguments {
    args -> handle_args(args)
  }
  // io.println("Hello from rippy!")
}

fn handle_args(args) {
  io.println("Hello from rippy!")

  //Grab the first two input parameters, default to 0 if not present
  let max_starting_point = case nth(args, 0) {
    Ok(arg) -> arg
    Error(_) -> "0"
  }

  let length = case nth(args, 1) {
    Ok(arg) -> arg
    Error(_) -> "0"
  }

  echo max_starting_point
  echo length
  // let input_check = case
  //   length == "default" || max_starting_point == "default"
  // {
  //   True -> "Missing Parameter"
  //   False -> "All Parameters Present"
  // }

  // echo input_check

  // let _pid = process.spawn(actor_loop)
}

//Helper Function to grab nth value in a list
fn nth(xs: List(String), i: Int) -> Result(String, Nil) {
  case xs {
    [] -> Error(Nil)
    // list too short
    [x, ..rest] ->
      case i {
        0 -> Ok(x)
        // found the element
        _ -> nth(rest, i - 1)
        // keep searching
      }
  }
}

fn actor_loop() {
  io.println("Actor Started")
}
