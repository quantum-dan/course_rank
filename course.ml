module StringSet = Set.Make(String)
module CourseMap = Map.Make(String)

type prereqs = StringSet.t CourseMap.t
type courses = string list

let (prs: prereqs ref) = ref (CourseMap.empty)
let (classes: courses ref) = ref ([])
let (taken: StringSet.t ref) = ref (StringSet.empty)

let build_set strs = List.fold_right StringSet.add strs StringSet.empty
let add_course strs =
  prs := CourseMap.add (List.hd strs) (build_set (List.tl strs)) !prs;
  classes := (List.hd strs) :: !classes
let build_data strsList = List.iter add_course strsList

let build_taken strs = taken := build_set strs

type course_data = { id: string; prereqs: int; requiredBy: int }
let print_course (cd: course_data) = Printf.printf "%s: required by %d\n" cd.id cd.requiredBy

let gen_course_data (course: string) (courses: courses) (pr: prereqs) =
  let pre = StringSet.cardinal (CourseMap.find course pr)
  and reqBy = CourseMap.cardinal (CourseMap.filter (fun _ strs -> StringSet.mem course strs) pr) in
  { id = course; prereqs = pre; requiredBy = reqBy }

let gen_courses_data (data: courses) (pr: prereqs) =
  List.map (fun c -> gen_course_data c data pr) data

let rank_courses (crs: courses) (prs: prereqs) = List.sort (fun a b -> b.requiredBy - a.requiredBy) (gen_courses_data crs prs)

let available_courses (crs: courses) (taken: StringSet.t) (prs: prereqs) =
  let rec prereqs cr = CourseMap.find cr prs
  and not_taken prs = StringSet.filter (fun pr -> not (StringSet.mem pr taken)) prs
  and has_reqs cr = (StringSet.cardinal (not_taken (prereqs cr))) = 0 in
  List.filter has_reqs crs

let recommended_courses () = rank_courses (available_courses !classes !taken !prs) !prs

let string_of_set (strs: StringSet.t) = String.concat " " (StringSet.elements strs)

let course_string (cd: course_data) (prs: prereqs) =
  let pr_str = string_of_set (CourseMap.find cd.id prs) in
  Printf.sprintf "%s (%d): %s" cd.id cd.requiredBy pr_str

let courses_string (cds: course_data list) (prs: prereqs) =
  String.concat "\n" (List.map (fun cd -> course_string cd prs) cds)

let usage = "Usage: course -courses <course file> -taken <taken file> -out <output file>.\n\
            The courses file should be formatted as course,prereq,prereq,... on each line, no spaces,\n\
            \tby course ID, prerequisites optional.  E.g. CS2,MATH1,CS1 means that CS2 requires MATH1 and CS1.\n\
            The taken file is a newline-separated list of courses taken so far.\n\
            The output file will be formatted as course (required by): prerequisites for all courses."

let specs (cf: string ref) (tf: string ref) (outf: string ref) = [
  ("-courses", Arg.Set_string cf, "The text file containing course info");
  ("-taken", Arg.Set_string tf, "The text file containing courses taken");
  ("-out", Arg.Set_string outf, "Where to write the results");
]

let () =
  let cf, tf, outf = ref "courses.txt", ref "taken.txt", ref "ranked.txt" in
  Arg.parse (specs cf tf outf) (fun _ -> ()) usage;
  build_data (Data.gen_course_data !cf);
  build_taken (Data.lines !tf);
  Data.write_file !outf (courses_string (rank_courses !classes !prs) !prs);
  List.iter print_course (recommended_courses ())
