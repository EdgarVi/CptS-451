-- Edgar Villasenor
-- CptS 451

-- Problem 1
SELECT firstname, lastname, title 
FROM UserTable LEFT OUTER JOIN Instructor on UserTable.userID = Instructor.instructorID 
WHERE Instructor.instructorID IN (
    SELECT instructorID 
    FROM Class 
    WHERE Major = 'CptS' AND Semester = 'Spring' AND Year = '2020');