--Level 1 – Basic SELECT (1–6)

--List all students
---Show: studentid, fullname, email, country, enrollmentyear.
SELECT * FROM students; 

--List all courses
---Show: courseid, coursecode, title, credits, departmentid.
SELECT * FROM courses;

--List all instructors
---Show: instructorid, fullname, departmentid.
SELECT * FROM instructors;

--List all departments in alphabetical order
---Sort by departmentname ascending.
SELECT * FROM Departments 
ORDER BY DepartmentName ASC;

--List all distinct student countries
---Only show each country once.
SELECT DISTINCT country FROM students;

--Show all students who enrolled in 2024
---Use enrollmentyear to filter.
SELECT * FROM students
WHERE EnrollmentYear>='2024-01-01'


--Level 2 – Filtering & Sorting (7–10)

---Show all courses with more than 5 credits
--List coursecode, title, credits.
SELECT coursecode,title,credits FROM courses
WHERE credits>5;

---Show all students from a specific country
--Example: all students from 'Belgium'.
SELECT * FROM students
WHERE country='Belgium';


---Show all courses that belong to a specific department
--Example: department 'Computer Science'.
SELECT courses.coursecode, courses.title, departments.departmentname FROM courses, departments
WHERE courses.departmentid = departments.departmentid;


---List all enrollments ordered by semester and then by student
--Show: courseid, studentid, semester, grade.
SELECT * FROM enrollments 
ORDER BY semester,student;


-- Level 3 – Simple JOINs (11–15)

-- Show all courses with their department names
-- Columns: coursecode, title, departmentname.
-- (Join Courses → Departments)
SELECT courses.coursecode, courses.title, departments.departmentname
FROM courses
LEFT JOIN departments ON departments.departmentid = courses.departmentid;

-- Show all instructors with their department names
-- Columns: fullname (instructor), departmentname.
SELECT instructors.fullname,departments.departmentname
FROM instructors
LEFT JOIN departments ON departments.departmentid = instructors.departmentid;


-- Show all students with the courses they are enrolled in
-- Columns: students.fullname, courses.coursecode, courses.title, enrollments.semester.
SELECT students.fullname, courses.coursecode, courses.title , enrollments.semester
FROM students
JOIN enrollments ON enrollments.studentid = students.studentid
JOIN courses ON enrollments.courseid = courses.courseid;


-- Show all students and their grades for each course
-- Columns: students.fullname, courses.coursecode, courses.title, grade.
SELECT students.fullname, courses.coursecode, courses.title, enrollments.grade
FROM students
JOIN enrollments ON enrollments.studentid = students.studentid
LEFT JOIN courses ON enrollments.courseid = courses.courseid;


-- Show all enrollments for one specific student
-- Example: student named 'Nazar Boyko'.
-- Include course title, semester, grade.
SELECT students.fullname, courses.title, enrollments.semester, enrollments.grade
FROM students
LEFT JOIN enrollments ON enrollments.studentid = students.studentid
LEFT JOIN courses ON enrollments.courseid = courses.courseid
WHERE students.fullname = 'Nazar Boyko';


-- 🔹 Level 4 – Aggregation & GROUP BY (16–20)

-- Count how many students come from each country
-- Columns: country, student_count.
-- Sort by student_count descending.
SELECT students.country , COUNT(students.studentid) AS StudentsFromCountry
FROM students
GROUP BY country
ORDER BY StudentsFromCountry DESC;


-- Count how many courses each department offers
-- Columns: departmentname, course_count.
SELECT departments.departmentname, COUNT(courses.courseid) AS CoursesCount
FROM departments,courses
WHERE courses.departmentid = departments.departmentid
GROUP BY departments.departmentname;
  

-- Count how many students are enrolled in each course
-- Show: coursecode, title, num_students.
-- Include only courses that have at least one enrollment.
SELECT courses.coursecode, courses.title, COUNT(students.studentid) AS num_students
FROM courses
RIGHT JOIN enrollments ON enrollments.courseid = courses.courseid
LEFT JOIN students ON enrollments.studentid = students.studentid
GROUP BY courses.coursecode, courses.title
HAVING COUNT(students.studentid) >= 1;


-- Count how many enrollments exist per semester
-- Columns: semester, num_enrollments.
SELECT enrollments.semester, COUNT(*) AS enrollment_count
FROM enrollments
GROUP BY semester
ORDER BY semester;


-- For each student, show how many courses they are taking
-- Columns: fullname, course_count.
-- Sort by course_count descending.
SELECT students.fullname, COUNT(courses.courseid) AS course_count
FROM students
RIGHT JOIN enrollments ON enrollments.studentid = students.studentid
LEFT JOIN courses ON enrollments.courseid = courses.courseid
GROUP BY students.fullname
ORDER BY course_count DESC;


-- 🔹 Level 5 – More Complex JOINs & Conditions (21–24)

-- Show all prerequisites for each course
-- Columns:
-- main.coursecode (the course)
-- main.title
-- pre.coursecode (the prerequisite course)
-- pre.title
-- (Self-join Courses via CoursePrerequisites)
SELECT c.coursecode , c.title,
		p.coursecode AS prereq_course, p.title AS prereq_course_title
FROM courseprerequisites AS pr
JOIN courses  c ON c.courseid	 = pr.courseid
JOIN courses  p ON p.courseid = pr.prerequisitecourseid;


-- List all courses that have no prerequisites
-- Show all courses that do not appear as courseid in CoursePrerequisites.
SELECT * 
FROM courses c 
JOIN courseprerequisites pr ON pr.courseid = c.courseid;


-- List all students who are taking any course from the 'Computer Science' department
-- Columns: students.fullname, courses.coursecode, courses.title, departmentname.
SELECT s_list.fullname, c_list.coursecode, c_list.title, d_list.departmentname
FROM enrollments e_list
INNER JOIN students s_list ON s_list.studentid = e_list.studentid
RIGHT JOIN courses c_list ON c_list.courseid = e_list.courseid
RIGHT JOIN departments d_list ON d_list.departmentid = c_list.departmentid;



-- Show all students who received grade 'A' in any course
-- Only list each student once (no duplicates).
SELECT DISTINCT * FROM students s_list
JOIN enrollments e_list ON e_list.studentid = s_list.studentid
WHERE e_list.grade = 'A';


-- 🔹 Level 6 – Subqueries & “Missing” Data (25–27)

-- Find students who are not enrolled in any course
-- List studentid, fullname.
-- (Use NOT IN, NOT EXISTS, or a LEFT JOIN).
SELECT s.studentid, s.fullname FROM students s
WHERE NOT EXISTS (
SELECT studentid 
FROM enrollments e
WHERE s.studentid = e.studentid
);


-- Find courses that currently have no students enrolled
-- List coursecode, title.
SELECT * FROM courses c
WHERE  c.courseid NOT IN (
	SELECT courseid FROM enrollments e
);


-- Find the course that has the highest number of enrollments
-- Show coursecode, title, num_enrollments.
-- (Use subquery or ORDER BY ... LIMIT 1.)
SELECT c.coursecode, c.title, COUNT(e.studentid) AS enrollments_count
FROM courses c
JOIN enrollments e ON e.courseid = c.courseid
GROUP BY c.coursecode, c.title
ORDER BY enrollments_count DESC;

);


-- 🔹 Level 7 – DDL / DML & “Real-life” Tasks (28–30)
INSERT INTO Students (studentid, fullname, email, country, enrollmentyear)
VALUES ('Jhon Doe', 'jondoe@mail.com', 'Belgium', '2024-09-01');

-- Insert a new student and enroll them into two courses
INSERT INTO enrollments(studentid,courseid,semester,grade)
VALUES (6, 3, 'Fall 2024', 'A')


-- Insert a new row into Students.
INSERT INTO students(fullname,email,country,enrollmentyear)
VALUES ('Leonardo Davinci','ld@mail.ru','France','2024-08-01')


-- Then insert two rows into Enrollments for that student for some semester.
INSERT INTO enrollments(studentid,courseid,semester,grade)
VALUES (7, 2, '2024-Fall', 'B');

INSERT INTO enrollments(studentid,courseid,semester,grade)
VALUES (7, 4, '2024-Spring', 'C');


-- Increase credits for all Computer Science courses by 1
UPDATE Courses
SET credits = credits + 1
WHERE departmentid IN (
    SELECT departmentid
    FROM Departments
    WHERE departmentname = 'Computer Science'
);



-- Create a view called StudentTranscript
-- The view should show:
-- studentid
-- student_name (from Fullname)
-- coursecode
-- course_title
-- semester
-- grad
-- departmentname

CREATE VIEW StudentTranscript AS
SELECT 
    s.studentid,
    s.fullname AS student_name,
    c.coursecode,
    c.title AS course_title,
    e.semester,
    e.grade,
    d.departmentname
FROM students s
JOIN enrollments e ON e.studentid = s.studentid
JOIN courses c ON c.courseid = e.courseid
JOIN departments d ON d.departmentid = c.departmentid;
