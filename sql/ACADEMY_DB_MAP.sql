

CREATE TABLE Departments
(
	DepartmentID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	DepartmentName VARCHAR(255) NOT NULL
);

CREATE TABLE Courses
(
	CourseID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	CourseCode VARCHAR(30) NOT NULL UNIQUE,
	Title VARCHAR (255) NOT NULL,
	Credits INT DEFAULT 0,
	DepartmentID INT NOT NULL,
	FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Students
( 
	StudentID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	Fullname VARCHAR(255) NOT NULL,
	Email VARCHAR(255) NOT NULL,
	Country VARCHAR(255) NOT NULL,
	EnrollmentYear DATE NOT NULL
);

CREATE TABLE Instructors
(
	InstructorID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	FullName VARCHAR(255) NOT NULL,
	DepartmentID INT NOT NULL,
	FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)	
);

CREATE TABLE CoursePrerequisites
(
	CourseID INT NOT NULL,
	PrerequisiteCourseID INT NOT NULL,
	PRIMARY KEY ( CourseID, PrerequisiteCourseID),
	FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)	,
	FOREIGN KEY (PrerequisiteCourseID) REFERENCES Courses(CourseID),
	CHECK (CourseID <> PrerequisiteCourseID)
);

CREATE TABLE Enrollments
(
	CourseID INT NOT NULL,
	StudentID INT NOT NULL,
	Semester VARCHAR(20) NOT NULL,	
	Grade VARCHAR(10) NOT NULL,	
	--Composite PrimaryKEY CONSTRAINT 
	PRIMARY KEY (CourseID,StudentID,Semester),
	FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
	FOREIGN KEY (StudentID) REFERENCES Students(StudentID)	
);

