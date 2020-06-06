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