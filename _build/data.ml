let lines (filename: string) =
  let in_file = open_in filename in
  let lstream = Stream.from (fun _ ->
      try Some (input_line in_file) with End_of_file -> close_in in_file; None) in
  Stream.npeek (Stream.count lstream) lstream

let genCourseData (filename: string) =
  List.map (fun str -> String.split_on_char ',') (lines filename)

let (coursesData: string list list) = [
  ["CHGN121"];
  ["GEGN101"];
  ["HASS100"];
  ["PHGN100"];
  ["CHGN122"; "CHGN121"];
  ["EDNS151"];
  ["CEEN210"];
  ["PHGN200"; "PHGN100"];
  ["CEEN241"; "PHGN100"];
  ["HASS200"; "HASS100"];
  ["CEEN310"; "PHGN100"; "CEEN241"];
  ["CEEN267"; "EDNS151"];
  ["CEEN311"; "CEEN241"];
  ["MEGN350"];
  ["MATH201"];
  ["CEEN331"; "CEEN267"];
  ["CEEN350"; "CEEN311"];
  ["CEEN314"; "CEEN311"];
  ["CEEN312"; "CEEN311"];
  ["CEEN312L"];
  ["MATH225"];
  ["CEEN415"; "CEEN312"];
  ["MEGN315"; "CEEN241"; "MATH225"];
  ["CEEN301"; "CHGN122"; "PHGN100"];
  ["CEEN381"; "CEEN310"];
  ["CEEN445"; "CEEN314"];
]

let (coursesTaken: string list) = [
]
