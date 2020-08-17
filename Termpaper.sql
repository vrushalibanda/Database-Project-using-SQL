create database schedule;

use schedule;

--Create table Student
CREATE TABLE Student (
	NetID varchar(20) not null,
	StudentName varchar(200),
	Major varchar(100),
	GraduationSemester varchar(100),
	Email varchar(200)
	CONSTRAINT Student_PK primary key (NetID)
);

CREATE TABLE Instructor (
	InstructorID varchar(20) not null,
	InstructorName varchar(200),
	InstructorOffice varchar(500)
	CONSTRAINT Instructor_PK primary key (InstructorID)
);

CREATE TABLE Book(
	BookID varchar(20),
	CourseBook varchar(500),
	CourseBookPublisher varchar(500)
	CONSTRAINT Book_PK primary key(BookID)
);


CREATE TABLE Course (
	Course# varchar(50),
	CourseName varchar(100),
	InstructorID varchar(20),
	BookID varchar(20),
	CreditHours int,
	CourseClassroom varchar(100)
	CONSTRAINT Course_PK primary key (Course#),
	CONSTRAINT InstructorID_FK foreign key (InstructorID) references Instructor(InstructorID),
	CONSTRAINT BookID_FK foreign key (BookID) references Book(BookID)
);

CREATE TABLE Enrollment(
	NetID varchar(20),
	Course# varchar(50),
	Grade varchar(10),
	DateOfEnrollment Date
	CONSTRAINT Enrollment_PK primary key (NetID,Course#),
	CONSTRAINT NetID_FK foreign key (NetID) references Student(NetID),
	CONSTRAINT Course#_FK foreign key (Course#) references Course(Course#)
);

---------------------------------------------- DATA INSERTION ------------------------------------------------------------

BULK
INSERT Student
FROM 'C:\Users\rajja\Desktop\GROUP PROJECT DBMS\student.csv'
WITH
(
FIELDTERMINATOR=',',
ROWTERMINATOR='\n'
)
GO

BULK
INSERT Instructor
FROM 'C:\Users\rajja\Desktop\GROUP PROJECT DBMS\Instructor.csv'
WITH
(
FIELDTERMINATOR=',',
ROWTERMINATOR='\n'
)
GO

BULK
INSERT Book
FROM 'C:\Users\rajja\Desktop\GROUP PROJECT DBMS\Book.csv'
WITH
(
FIELDTERMINATOR=',',
ROWTERMINATOR='\n'
)
GO

BULK
INSERT Course
FROM 'C:\Users\rajja\Desktop\GROUP PROJECT DBMS\Course.csv'
WITH
(
FIELDTERMINATOR=',',
ROWTERMINATOR='\n'
)
GO

BULK
INSERT Enrollment
FROM 'C:\Users\rajja\Desktop\GROUP PROJECT DBMS\Enrollment.csv'
WITH
(
FIELDTERMINATOR=',',
ROWTERMINATOR='\n'
)
GO

------------------------------------------------ QUERIES ---------------------------------------------------------


--1.	Count the number of students who are graduating in the same semester.

select GraduationSemester, count(*) as 'No_Of_Students'
from Student
group by GraduationSemester


--2.	Display the students name and major who have taken BAN 610.

select s.StudentName, s.Major
from student s inner join Enrollment e on s.NetID=e.NetID
where e.Course#='BAN610'

--3 Display the NetID and student name of the students who have taken more than 8 courses in year 2018.

select x.NetID, x.StudentName 
from 
(
select e.NetID,s.[StudentName], count(e.course#)as'count'
from Enrollment e inner join Student s on e.NetID=s.NetID
where year([DateOfEnrollment]) = '2018'
group by e.[NetID], s.[StudentName]
having count(Course#)>8
)as x where x.[count]>8




--4.Display the NetID and the total credit hours taken by each student in 2018.

select s.NetID, sum(c.CreditHours) as 'CreditHours'
from Student s
inner join Enrollment e on s.NetID=e.NetID
inner join Course c on e.Course#=c.Course#
where year(DateOfEnrollment)='2018'
group by s.NetID;


--5.	Display the instructors name and the number of course books prescribed by each instructor.

select i.InstructorName, count(b.BookID) as 'No_Of_Course_Books_Prescribed'
from Instructor i
inner join Course c on i.InstructorID=c.InstructorID
inner join Book b on c.BookID=b.BookID
group by i.InstructorName, i.InstructorID
















