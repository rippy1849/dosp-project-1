import argv
import gleam/bool
import gleam/erlang/process
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/otp/actor

// pub type Message(e) {
//   Push(e)
//   Pop(process.Subject(Result(e, Nil)))
//   Shutdown
//   BeginCalculation
// }

// Logger messages
pub type LogMsg {
  Log(Int, Bool)
}

// Worker messages
pub type WorkerMsg {
  Work(List(Int), Int)
}

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

  // echo max_starting_point
  // echo length

  //Turn both inputs into ints to be used. Default to 0 in event that input is not an int
  let length = case int.parse(length) {
    Ok(length) -> length
    Error(_) -> 0
  }

  let max_starting_point = case int.parse(max_starting_point) {
    Ok(max_starting_point) -> max_starting_point
    Error(_) -> 0
  }
  // let assert Ok(actor) =
  //   actor.new([]) |> actor.on_message(handle_message) |> actor.start

  // let subject = actor.data

  // process.send(subject, Push(#(1, "Joe")))

  // let #(o1, o2) = case process.call(subject, 10, Pop) {
  //   Ok(#(o1, o2)) -> #(o1, o2)
  //   Error(_) -> #(0, "Default")
  // }
  // echo o1

  // Start one logger

  // let waiting_channel = process.new_subject()

  // let assert Ok(waiting_started) =
  //   actor.new(Nil)
  //   |> actor.on_message(logger_handle)
  //   |> actor.start

  // let waiting_subject = waiting_started.data

  let waiting_channel = process.new_subject()

  let assert Ok(logger_started) =
    actor.new(waiting_channel)
    |> actor.on_message(logger_handle)
    |> actor.start

  let logger_subject = logger_started.data

  // let test_sub = spawn_worker(logger_subject)
  // process.send(test_sub, Work("task!"))

  // process.send(logger_subject, Log("Hello"))
  // echo 2

  let tasks_per_worker = 1

  // let upper_task_limit = max_starting_point / tasks_per_worker

  // let upper_task_limit = case
  //   upper_task_limit * tasks_per_worker == max_starting_point
  // {
  //   True -> upper_task_limit
  //   False -> upper_task_limit + 1
  // }

  // let worker_list = list.range(1, upper_task_limit)

  // let updated_list =
  //   list.map(worker_list, fn(n) {
  //     case n == 1 {
  //       True -> 1
  //       False -> n + 2 * { tasks_per_worker - 1 }
  //     }
  //   })

  // echo updated_list

  // process.spawn()

  // let hi =
  //   list.map(updated_list, fn(n) {
  //     // let task_list = list.range(n, n + tasks_per_worker - 1)

  //     // let task_list = case n + tasks_per_worker > max_starting_point {
  //     //   True -> {
  //     //     list.range(n, max_starting_point)
  //     //   }
  //     //   False -> {
  //     //     list.range(n, n + tasks_per_worker - 1)
  //     //   }
  //     // }

  //     // echo task_list
  //     // let task_list = list.range(n, n + tasks_per_worker - 1)
  //     // echo task_list

  //     // case n % tasks_per_worker == 0 {
  //     //   True -> echo []
  //     //   False -> echo task_list
  //     // }

  //     let task_list = [1, 2]

  //     let assert Ok(worker_started) =
  //       actor.new(logger_subject)
  //       |> actor.on_message(worker_handle)
  //       |> actor.start

  //     let work_sub = worker_started.data
  //     process.send(work_sub, Work(task_list, length))
  //   })

  // process.send(waiting_channel, "a")
  // process.send(waiting_channel, "a")

  // wait_for_done(waiting_channel, 0)

  process.spawn(fn() {
    spawn_worker(
      logger_subject,
      max_starting_point,
      1,
      length,
      tasks_per_worker,
    )
  })

  wait_for_done(waiting_channel, max_starting_point - 1)
  // echo 5
  // process.sleep(10_000)
  // echo hi
  // let assert Ok(worker_started) =
  //   actor.new(logger_subject)
  //   |> actor.on_message(worker_handle)
  //   |> actor.start

  // // *** return the subject from the lambda ***
  // let work_sub = worker_started.data
  // process.send(work_sub, Work("task!"))

  // echo hi

  // list.each(hi, fn(n) { echo n })

  // let workers =
  //   worker_list
  //   |> list.map(fn(_i) { spawn_worker(logger_subject) })

  // echo workers

  // Spawn N workers, all share the same logger subject
  // let workers =
  //   list.range(1, 5)
  //   |> list.map(fn(n) {
  //     let assert Ok(worker_started) =
  //       actor.new(logger_subject)
  //       // same subject passed into each
  //       |> actor.on_message(worker_handle)
  //       |> actor.start

  //     worker_started.data
  //   })

  // list.each(workers, fn(w) { echo w })

  // let sub_2 = case list.first(workers) {
  //   Ok(sub_2) -> sub_2
  //   Error(_) -> work_sub
  // }
  // process.send(sub_2, Work("task!"))

  // Send some jobs to each worker
  // hi
  // |> list.each(fn(w) { process.send(w, Work("task!")) })
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

fn logger_handle(
  state: process.Subject(String),
  msg: LogMsg,
) -> actor.Next(process.Subject(String), LogMsg) {
  case msg {
    Log(number, is_lukas) -> {
      // io.debug("Log: " <> text)
      // io.println(text)

      case is_lukas {
        True ->
          io.println(int.to_string(number) <> " " <> bool.to_string(is_lukas))
        False -> Nil
      }
      // io.println(int.to_string(number) <> " " <> bool.to_string(is_lukas))
      // echo 1
      process.send(state, "Complete")
      actor.continue(state)
    }
  }
}

// Worker actor, forwards everything to logger
fn worker_handle(
  logger: process.Subject(LogMsg),
  msg: WorkerMsg,
) -> actor.Next(process.Subject(LogMsg), WorkerMsg) {
  case msg {
    Work(task_list, length) -> {
      // echo 1
      // process.send(logger, Log("Worker did: " <> task))
      // echo starting_number
      // echo task_list
      list.each(task_list, fn(n) {
        let task = list.range(n, n + length - 1)
        let sequence_list = list.map(task, fn(n) { n * n })

        let sum = list.fold(sequence_list, 0, fn(n, acc) { acc + n })

        let sqr_root = case int.square_root(sum) {
          Ok(root) -> root
          Error(_) -> 0.0
        }

        let is_int = is_int(sqr_root)
        // echo is_int

        process.send(logger, Log(n, is_int))
      })

      actor.continue(logger)
    }
  }
}

// Spawn one worker and return its subject

fn is_int(x: Float) -> Bool {
  x == float.floor(x)
}

fn wait_for_done(channel, remaining) {
  //Wait to receive message
  // io.println(int.to_string(remaining))

  let msg = case process.receive(channel, within: 10_000) {
    Ok(msg) -> msg
    Error(_) -> "default"
  }

  // io.println(msg)

  // case msg == "default" {
  //   True -> wait_for_done(channel, remaining)
  //   False -> Nil
  // }

  case remaining > 0 {
    True -> wait_for_done(channel, remaining - 1)
    False -> {
      io.println("Done")
    }
  }
}

fn spawn_worker(boss_subject, num_calcs, start_point, length, tasks_per_worker) {
  let left_tree_calcs = num_calcs / 2
  let right_tree_calcs = num_calcs - left_tree_calcs

  let right_start_point = start_point + left_tree_calcs

  // io.println(
  //   "Left: "
  //   <> int.to_string(left_tree_calcs)
  //   <> ", Right: "
  //   <> int.to_string(right_tree_calcs)
  //   <> ", Num Calcs: "
  //   <> int.to_string(num_calcs),
  // )

  // echo 3
  // io.println("Num Calcs: " <> int.to_string(num_calcs))

  case { tasks_per_worker } >= num_calcs {
    True -> {
      process.spawn(fn() {
        do_calculation(boss_subject, num_calcs, start_point, length)
      })
      // process.spawn(fn() {
      //   do_calculation(boss_subject, num_calcs, right_start_point, length)
      // })
    }
    False -> {
      // echo 1

      process.spawn(fn() {
        spawn_worker(
          boss_subject,
          left_tree_calcs,
          start_point,
          length,
          tasks_per_worker,
        )
      })

      process.spawn(fn() {
        spawn_worker(
          boss_subject,
          right_tree_calcs,
          right_start_point,
          length,
          tasks_per_worker,
        )
      })
    }
  }
}

fn do_calculation(boss_subject, num_calcs, start_point, length) {
  // echo 2

  let task_list = list.range(start_point, start_point + num_calcs - 1)

  // echo task_list

  let assert Ok(worker_started) =
    actor.new(boss_subject)
    |> actor.on_message(worker_handle)
    |> actor.start

  let work_sub = worker_started.data
  process.send(work_sub, Work(task_list, length))
}
