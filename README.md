# Course Rank

This is a simple program to help decide on an optimal course schedule for college students.

It determines which courses you are currently able to take (by prerequisites), then ranks them according to how many other classes require them, so you can fill the prerequisites for as many courses as possible as quickly as possible.

It will also produce a full plan that fulfils prerequisites as quickly as possible.

## Building
`ocamlopt -o course.native data.ml course.ml` or `ocamlbuild course.native`.  In addition, there is the pre-built OCaml bytecode file `course`, if you do not want to build it yourself.

## Usage
Note: to use `course` instead of compiling it yourself, the following is the exact same, but replace `./courses.native` with `ocamlrun course`.

By default, courses with prerequisites go in the file `courses.txt`.  A list of already-taken courses goes in the file `taken.txt`.

Format:

* `courses.txt`: Each line is a course ID (e.g. MATH121), followed by its prerequisites, separated by commas (no spaces).  For example, `CS2,MATH1,CS1` would be CS2 requires MATH1 and CS1. 
* `taken.txt`: Each line is one course ID that you have taken.

Then, with those files in the working directory, just run `./courses.native`.  It will print out the course ranking.  It will also write the full list of courses, with the number they are required by and a list of prerequisites, to `ranked.txt` by default.  It will write the full plan to `full-<ranked file>`, e.g. `full-ranked.txt`.

To specify the files, run instead `./courses.native -courses <course file> -taken <taken file> -out <output file>`.
