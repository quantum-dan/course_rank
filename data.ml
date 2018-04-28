let list_of_stream stream =
  let list = ref [] in
  Stream.iter (fun i -> list := i :: !list) stream;
  !list

let lines (filename: string) =
  let in_file = open_in filename in
  let lstream = Stream.from (fun _ ->
      try Some (input_line in_file) with End_of_file -> close_in in_file; None) in
  list_of_stream lstream

let gen_course_data (filename: string) =
  List.map (fun str -> String.split_on_char ',' str) (lines filename)

let write_file (filename: string) (data: string) =
  let out = open_out filename in
  Printf.fprintf out "%s" data;
  close_out out
