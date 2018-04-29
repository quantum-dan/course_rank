open Course

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
  Data.write_file ("full-" ^ !outf) (courses_string (Plan.plan !classes !prs) !prs);
  List.iter print_course (recommended_courses ())
