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
SELECT Student.studentid, sub.classid, sub.assignmentno, sub.submissiondate, sub.score
FROM Student
INNER JOIN (
    SELECT *
    FROM Submit
) AS sub ON sub.studentID = Student.studentID
INNER JOIN (
    SELECT *
    FROM Assignment
    INNER JOIN (
        SELECT *
        FROM Class
        WHERE major = 'CptS' AND coursenum = '451'
    ) cl ON cl.classID = Assignment.classID
) AS ca ON ca.assignmentNo = sub.assignmentNo;

-- Problem 9
SELECT Class.major, Class.coursenum, Class.enrollmentlimit, er.numstudents
FROM Class
INNER JOIN (
    SELECT classID, COUNT(studentID) as numstudents
    FROM Enroll
    GROUP BY classID
) as er on Class.classID = er.classID
WHERE Class.enrollmentlimit < er.numstudents;

-- Problem 10
SELECT Student.studentID, po.classID, po.assignmentNo, po.content
FROM Student
INNER JOIN (
    SELECT userID, classID, assignmentNo, content
    FROM Post
    INNER JOIN (
        SELECT *
        FROM PostAbout
    ) AS pa ON Post.postID = pa.postID
) AS po ON po.userID = Student.studentID
INNER JOIN (
    SELECT Student.studentID
    FROM Student
    WHERE NOT EXISTS (
        SELECT NULL
        FROM Submit
        WHERE Submit.studentID = Student.studentID
    ) 
) AS sub ON sub.studentID = Student.studentID;