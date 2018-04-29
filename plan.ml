open Course

let rec firstn (n: int) xs = match xs with
  | [] -> failwith "empty list in firstn"
  | x::xs -> if n <= 1 then [x] else x::firstn (n - 1) xs

(* This module determines the ideal plan *)

(* Courses to take per semester *)
let per_semester = 5

let plan (classes: courses) (prs: prereqs) =
  let classes = ref classes
  and result = ref []
  and taken = ref (StringSet.empty) in
  while (List.length !classes > 0) do
    let ranked = rank_courses (available_courses !classes !taken prs) prs in
    let len = if (List.length ranked >= per_semester) then per_semester else List.length ranked in
    let first = firstn len ranked in
    let first_ids = List.map (fun x -> x.id) first in
    result := List.append !result first;
    List.iter (fun x -> taken := StringSet.add x !taken) first_ids;
    List.iter (fun x -> classes := List.filter (fun y -> y != x) !classes) first_ids
  done;
  !result
