-- 1. Departments
INSERT INTO Departments (DepartmentName)
VALUES
('Computer Science'),
('Business Administration'),
('Mathematics'),
('Physics'),
('Literature');

-- 2. Courses
-- IDs will be:
-- 1: CS101, 2: CS102, 3: CS201, 4: BUS101, 5: BUS202, 6: MATH101, 7: MATH201, 8: PHY101, 9: LIT101
INSERT INTO Courses (CourseCode, Title, Credits, DepartmentID)
VALUES
('CS101',  'Introduction to Programming', 5, 1),
('CS102',  'Data Structures',             6, 1),
('CS201',  'Operating Systems',           6, 1),

('BUS101', 'Principles of Management',    4, 2),
('BUS202', 'Marketing Basics',            5, 2),

('MATH101','Calculus I',                  5, 3),
('MATH201','Linear Algebra',              5, 3),

('PHY101', 'Classical Mechanics',         5, 4),

('LIT101', 'World Literature',            3, 5);

-- 3. Students
-- IDs will be: 1..5 in this order
INSERT INTO Students (Fullname, Email, Country, EnrollmentYear)
VALUES
('Sevda Nazarova', 'sevda@example.com',   'Belgium', '2024-09-01'),
('Nazar Boyko',     'nazar@example.com',   'Ukraine', '2024-09-01'),
('Alice Johnson',   'alice@example.com',   'USA',     '2023-09-01'),
('Mark Schmidt',    'mark@example.com',    'Germany', '2023-09-01'),
('Fatima Ali',      'fatima@example.com',  'Turkey',  '2024-09-01');

-- 4. Instructors
INSERT INTO Instructors (FullName, DepartmentID)
VALUES
('Dr. James Miller',   1),
('Prof. Laura Collins',1),
('Dr. Jacob Werner',   2),
('Dr. Sarah Kim',      3),
('Prof. Anna Petrova', 5);

-- 5. Course prerequisites
-- CS102 requires CS101
-- CS201 requires CS102
-- MATH201 requires MATH101
INSERT INTO CoursePrerequisites (CourseID, PrerequisiteCourseID)
VALUES
(2, 1),  -- CS102 ← CS101
(3, 2),  -- CS201 ← CS102
(7, 6);  -- MATH201 ← MATH101

-- 6. Enrollments
INSERT INTO Enrollments (CourseID, StudentID, Semester, Grade)
VALUES
-- Sevda (StudentID = 1)
(1, 1, '2024-Fall', 'A'),
(4, 1, '2024-Fall', 'B'),

-- Nazar (StudentID = 2)
(1, 2, '2024-Fall', 'A'),
(6, 2, '2024-Fall', 'B'),

-- Alice (StudentID = 3)
(1, 3, '2023-Fall',   'A'),
(2, 3, '2024-Spring', 'A'),

-- Mark (StudentID = 4)
(6, 4, '2023-Fall',   'C'),
(7, 4, '2024-Spring', 'B'),

-- Fatima (StudentID = 5)
(4, 5, '2024-Fall',   'A'),
(9, 5, '2024-Fall',   'B');


##Run on host VM.
docker exec -t postgress_container pg_dump -U db_user academy > populated_academy_backup.sql
