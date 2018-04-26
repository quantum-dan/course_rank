# Course Rank

This is a simple program to help decide on an optimal course schedule for college students.

It determines which courses you are currently able to take (by prerequisites), then ranks them according to how many other classes require them, so you can fill the prerequisites for as many courses as possible as quickly as possible.

## Building & Usage

For now (since I can't be bothered to write a proper interactive system as it's mostl yfor personal use), enter the data into the file data.ml:

* Required courses: the first item in each list is the course ID; the following items are the prerequisites.  For example, `["CS2"; "MATH1"; "CS1"]` means that this is the course CS2, which requires MATH1 and CS1.  If there are no prerequisites, the list should just contain the course ID, e.g. `["CS1"]`.  Corequisites are not currently supported.
* Courses taken so far: just a list of strings with the course IDs.

The file currently has examples in it; fill out with your own courses as appropriate.

Then, compile the program like so (requires ocaml):

`ocamlopt -o courses data.ml course.ml`

And run `./courses`.  It will print out the ranking of currently available courses.
