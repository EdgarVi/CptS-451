-- Edgar Villasenor
-- CptS 451

-- Problem 1
SELECT firstname, lastname, title 
FROM UserTable LEFT OUTER JOIN Instructor on UserTable.userID = Instructor.instructorID 
WHERE Instructor.instructorID IN (
    SELECT instructorID 
    FROM Class 
    WHERE Major = 'CptS' AND Semester = 'Spring' AND Year = '2020');

-- Problem 2
SELECT Temp.classID, class.major, class.coursenum, Temp.numStudents 
FROM (
    SELECT Temp.classID, Temp.numStudents
    FROM (SELECT classID, COUNT(classID) as numStudents 
    FROM Enroll 
    GROUP BY classID
) AS TEMP) as Temp, Class
WHERE Temp.classID = Class.classID AND Temp.numStudents > 10;

-- Problem 3
SELECT major, coursenum, title
FROM Course 
LEFT OUTER JOIN Prerequisite prereq USING (major, coursenum)
WHERE prereq.major IS NULL;

-- Problem 4
SELECT Post.userID, Post.timestamp, Temp.count
FROM (
    SELECT userID, timestamp, kind, COUNT(timestamp) as count
    FROM Post
    WHERE kind = 'Comment'
    GROUP BY userID, timestamp, kind
    ) AS Temp, Post
WHERE Temp.userID = Post.userID AND Temp.count > 1
GROUP BY Post.userID, Post.timestamp, Temp.count;

-- Problem 5
SELECT  classID, major, coursenum, semester, year, enrollmentlimit
FROM Class
WHERE enrollmentlimit = (
    SELECT MAX(enrollmentlimit)
    FROM Class
);

-- Problem 6
SELECT Class.classID, Class.major, Class.coursenum, Class.semester, Class.year, Temp.enrollmentlimit
FROM Class
INNER JOIN (
    SELECT major, MAX(enrollmentlimit) AS enrollmentlimit
    FROM Class
    GROUP BY major
) Temp ON Class.major = Temp.major AND Class.enrollmentlimit = Temp.enrollmentlimit;

-- Problem 7
SELECT UserTable.firstname, UserTable.lastname, UserTable.userID, sec.csgpa, er.GPA
FROM UserTable
INNER JOIN (
    SELECT studentID, AVG(grade) as GPA
    FROM Enroll
    GROUP BY studentID
) er ON UserTable.userID = er.studentID
INNER JOIN (
    SELECT Enroll.studentID, AVG(enroll.grade) csgpa
    FROM Enroll
    INNER JOIN (
        SELECT *
        FROM Class
        WHERE major = 'CptS'
        GROUP BY classID
    ) cl ON Enroll.classID = cl.classID
    GROUP BY Enroll.studentID
) sec ON UserTable.userID = sec.studentID
WHERE sec.csgpa > er.GPA;

-- Problem 8