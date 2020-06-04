
CREATE TABLE UserTable (
	userID CHAR(8),
	firstName VARCHAR,
	lastName VARCHAR,
	email VARCHAR(50),
	PRIMARY KEY (userID) 
);

CREATE TABLE Instructor(
	instructorID CHAR(8),
	title VARCHAR,
	PRIMARY KEY (instructorID), 
	FOREIGN KEY (instructorID) REFERENCES UserTable(userID)
);

CREATE TABLE Student(
	studentID CHAR(8),
	major VARCHAR,
	PRIMARY KEY (studentID), 
	FOREIGN KEY (studentID) REFERENCES UserTable(userID)
);

CREATE TABLE Course (
	major VARCHAR,
	courseNum CHAR(3),
	title VARCHAR,
	PRIMARY KEY (major,courseNum)
);

CREATE TABLE Prerequisite (
	major VARCHAR,
	courseNum CHAR(3),
	prereqMajor VARCHAR,
	prereqCourseNum CHAR(3),
	PRIMARY KEY (major,courseNum,prereqMajor,prereqCourseNum),
	FOREIGN KEY (major,courseNum) REFERENCES Course (major,courseNum),
	FOREIGN KEY (prereqMajor,prereqCourseNum) REFERENCES Course (major,courseNum)
);

CREATE TABLE Class (
	classID VARCHAR,
	major VARCHAR NOT NULL,      
	courseNum CHAR(3) NOT NULL,  
	semester VARCHAR(10),
	year CHAR(4),
	instructorID CHAR(8) NOT NULL,     
	enrollmentlimit INTEGER,
	PRIMARY KEY (classID),
	FOREIGN KEY (major,courseNum) REFERENCES Course(major,courseNum),
	FOREIGN KEY (instructorID) REFERENCES Instructor(instructorID)
);

CREATE TABLE Enroll (
	studentID CHAR(8),
    classID VARCHAR,
	grade INTEGER,
	PRIMARY KEY (classID,studentID),
	FOREIGN KEY (classID) REFERENCES Class(classID),
	FOREIGN KEY (studentID) REFERENCES Student(studentID)
);

CREATE TABLE Assignment (
	classID VARCHAR,
	assignmentNo INTEGER,
	title VARCHAR,
	weight INTEGER, 
	deadline DATE,
	PRIMARY KEY (classID, assignmentNo),
	FOREIGN KEY (classID) REFERENCES Class(classID)
);

CREATE TABLE Submit (
	studentID CHAR(8),
	classID VARCHAR,
	assignmentNo INTEGER,
	score INTEGER,
	submissionDate DATE,
	PRIMARY KEY (studentID, classID, assignmentNo),
	FOREIGN KEY (classID, assignmentNo) REFERENCES Assignment(classID, assignmentNo),
	FOREIGN KEY (studentID) REFERENCES Student(studentID)
);


CREATE TABLE Post (
	postID INTEGER,
	userID CHAR(8) NOT NULL, 
	kind VARCHAR,
	timestamp DATE,
	content VARCHAR,
	popularity INTEGER,  
	PRIMARY KEY (postID),
	FOREIGN KEY (userID) REFERENCES UserTable(userID)
);

CREATE TABLE PostAbout (
	postID INTEGER,
	classID VARCHAR,
	assignmentNo INTEGER,
	PRIMARY KEY (postID,classID,assignmentNo),
	FOREIGN KEY (postID) REFERENCES Post(postID),
	FOREIGN KEY (classID, assignmentNo) REFERENCES Assignment(classID, assignmentNo)
);