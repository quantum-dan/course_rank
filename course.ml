module StringSet = Set.Make(String)
module CourseMap = Map.Make(String)

type prereqs = StringSet.t CourseMap.t
type courses = string list

let (prs: prereqs ref) = ref (CourseMap.empty)
let (classes: courses ref) = ref ([])
let (taken: StringSet.t ref) = ref (StringSet.empty)

let buildSet strs = List.fold_right StringSet.add strs StringSet.empty
let addCourse strs =
  prs := CourseMap.add (List.hd strs) (buildSet (List.tl strs)) !prs;
  classes := (List.hd strs) :: !classes
let buildData strsList = List.iter addCourse strsList

let buildTaken strs = taken := buildSet strs

type courseData = { id: string; prereqs: int; requiredBy: int }
let printCourse (cd: courseData) = Printf.printf "%s: required by %d\n" cd.id cd.requiredBy

let genCourseData (course: string) (courses: courses) (pr: prereqs) =
  let pre = StringSet.cardinal (CourseMap.find course pr)
  and reqBy = CourseMap.cardinal (CourseMap.filter (fun _ strs -> StringSet.mem course strs) pr) in
  { id = course; prereqs = pre; requiredBy = reqBy }

let genCoursesData (data: courses) (pr: prereqs) =
  List.map (fun c -> genCourseData c data pr) data

let rankCourses (crs: courses) (prs: prereqs) = List.sort (fun a b -> b.requiredBy - a.requiredBy) (genCoursesData crs prs)

let availableCourses (crs: courses) (taken: StringSet.t) (prs: prereqs) =
  let rec prereqs cr = CourseMap.find cr prs
  and notTaken prs = StringSet.filter (fun pr -> not (StringSet.mem pr taken)) prs
  and hasReqs cr = (StringSet.cardinal (notTaken (prereqs cr))) = 0 in
  List.filter hasReqs crs

let recommendedCourses () = rankCourses (availableCourses !classes !taken !prs) !prs

let () =
  buildData Data.coursesData;
  buildTaken Data.coursesTaken;
  List.iter printCourse (recommendedCourses ())
