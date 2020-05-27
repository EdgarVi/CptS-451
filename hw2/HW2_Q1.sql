-- Edgar Villasenor
-- CptS 451 HW 2 
-- 24 May 2020


-- Entities
CREATE TABLE User (
    firstName VARCHAR(30), -- VARCHAR, variable length data
    lastName VARCHAR(30),
    email VARCHAR(30),
    userID CHAR(8),
    PRIMARY KEY(userID)
);

-- A user may have more than one phone, must create a table for Phone
CREATE TABLE if not exists Phones(
    phoneNum CHAR(10), -- CHAR, fixed length data
    phoneType VARCHAR(25),
    PRIMARY KEY(phoneNum),
    FOREIGN KEY(userID) REFERENCES User(userID)
);

CREATE TABLE Instructor(
    title VARCHAR(30),
    PRIMARY KEY(userID),
    FOREIGN KEY(userID) REFERENCES User(userID) -- userID is a foreign key
);

CREATE TABLE Student(
    major VARCHAR(30), 
    PRIMARY KEY(userID),
    FOREIGN KEY(userID) REFERENCES User(userID) -- userID is a foreign key
);

CREATE TABLE Assignment(
    title VARCHAR(30),
    deadline DATE,
    weight DECIMAL, -- assuming weight is represented as decimal e.g. 0.15 is the weight of midterm
    assignmentNo INT,
    PRIMARY KEY(assignmentNo)
);

-- since popularity is a derived attribute, you would compute in business logic of application
CREATE TABLE Post(
    kind VARCHAR(25),
    timestamp CURRENT_TIMESTAMP,
    content VARCHAR(MAX), -- Let users make really long posts
    postID CHAR(10),
    PRIMARY KEY(postID)
);

CREATE TABLE Class(
    classID CHAR(8),
    enrollmentLimit INT,
    enddate DATE,
    startdate DATE,
    sectionNo INT,
    semester VARCHAR(12),
    year INT,
    PRIMARY KEY(classID)
);

CREATE TABLE Course(
    courseNum CHAR(3), -- assume course num must be 3 numbers e.g. 451
    major CHAR(45),
    title CHAR(45),
    PRIMARY KEY(courseNum, major) -- PRIMARY KEY(451, CptS)
);

-- Relations

-- self relation
CREATE TABLE Responds(
    responseToID CHAR(10),
    responseFromID CHAR(10),
    PRIMARY KEY(responseToID, responseFromID),
    FOREIGN KEY(responseToID) REFERENCES Post(responseToID),
    FOREIGN KEY(responseFromID) REFERENCES Post(responseFromID)
);

-- Many Posts to one User. Total participation, all posts must belong to a user
CREATE TABLE Publish(
    postID CHAR(10) NOT NULL, -- enforce total participation
    userID CHAR(8),
    PRIMARY KEY(postID, userID),
    FOREIGN KEY(postID) REFERENCES Post(postID),
    FOREIGN KEY(userID) REFERENCES User(userID)
);

-- Post about Assignment
CREATE TABLE About(
    postID CHAR(10),
    assignmentNo INT,
    PRIMARY KEY(postID, assignmentNo),
    FOREIGN KEY(postID) REFERENCES Post(postID),
    FOREIGN KEY(assignmentNo) REFERENCES Assignment(assignmentNo)
);

-- Student submits assignment
CREATE TABLE Submit(
    score DECIMAL, -- Asumming assignments scored: 80/100
    submissionDate CURRENT_TIMESTAMP,
    assignmentNo INT,
    userID CHAR(8)
    PRIMARY KEY(assignmentNo, userID),
    FOREIGN KEY(assignmentNO) REFERENCES Assignment(assignmentNo),
    FOREIGN KEY(userID) REFERENCES User(userID)
);

CREATE TABLE Enroll(
    grade CHAR(2) -- A, A-, B+, ...
    userID CHAR(8),
    classID CHAR(8),
    PRIMARY KEY(userID, classID),
    FOREIGN KEY(userID) REFERENCES Student(userID),
    FOREIGN KEY(classID) REFERENCES Class(classID)
);

CREATE TABLE Teach(
    userID CHAR(8),
    classID CHAR(8),
    PRIMARY KEY(userID, classID),
    FOREIGN KEY(userID) REFERENCES Instructor(userID),
    FOREIGN KEY(classID) REFERENCES Class(classID)
);

CREATE TABLE BelongsTo(
    assignmentNo INT,
    classID CHAR(8),
    PRIMARY KEY(assignmentNo),
    FOREIGN KEY(assignmentNo) REFERENCES Assignment(assignmentNo),
    FOREIGN KEY(classID) REFERENCES Class(classID)
);

CREATE TABLE Prerequisite(
    majorPrereqOf CHAR(45),
    majorPrereqFor CHAR(45),
    courseNumPrereqOf VARCHAR(3),
    courseNumPrereqFor VARCHAR(3),
    PRIMARY KEY (courseNumPrereqOf, courseNumPrereqFor, majorPrereqOf, majorPrereqFor),
    FOREIGN KEY(courseNumPrereqOf, majorPrereqOf) REFERENCES Course(courseNumPrereqOf, majorPrereqOf),
    FOREIGN KEY(courseNumPrereqFor, majorPrereqFor) REFERENCES Course(courseNumPrereqFor, majorPrereqFor)
);

CREATE TABLE OfferingOf(
    classID CHAR(8),
    courseNum CHAR(3), -- assume course num must be 3 numbers e.g. 451
    major CHAR(45),
    PRIMARY KEY(classID, courseNum, major),
    FOREIGN KEY(classID) REFERENCES Class,
    FOREIGN KEY(courseNum, major) REFERENCES Course
);