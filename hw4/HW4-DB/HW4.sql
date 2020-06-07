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