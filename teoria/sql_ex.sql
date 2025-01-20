Given the following schema:
  LECTURER(Id, Surname, Dept)
  STUDENT(Id, Surname)
  COURSE(Code, Name)
  EDITION(Course, Year, Lecturer)
  EXAM(Student, Course, Year)
Write a SQL query that returns the distinct
surnames that belong both to students and to
lecturers.
-- First version
SELECT DISTINCT Surname FROM LECTURER
INTERSECT
SELECT DISTINCT Surname FROM STUDENT
-- Second version
SELECT DISTINCT LECTURER.Surname
FROM LECTURER, STUDENT
WHERE LECTURER.Surname = STUDENT.Surname
-- Third version
SELECT L.Surname FROM
LECTURER AS L JOIN STUDENT AS S 
ON L.Surname = S.Surname

Given the following schema:
  LECTURER(Id, Surname, Dept)
  STUDENT(Id, Surname)
  COURSE(Code, Name)
  EDITION(Course, Year, Lecturer)
  EXAM(Student, Course, Year)
Write a SQL query that returns the surnames of
those lecturers that have taught in courses for
which at least 10 students passed the exam.

SELECT DISTINCT L.Surname 
FROM LECTURES AS L, EDITION AS ED, EXAM AS E
WHERE L.Id = ED.id AND E.Course = ED.Course AND E.Year = ED.Year
GROUP BY L.Id, L.Surname, E.Course , E.Year
HAVING COUNT(*) >= 10

Given the following schema:
TRAIN(Code, Departure, Arrival, Mile)
Write a SQL query that returns the minimum and
the maximum length of the routes between Boston
and Chicago without interchanges.
SELECT MIN(Mile), MAX(Mile) FROM TRAIN
WHERE Departure = "Boston" AND Arrival = "Chicago"


Given the following schema:
REGION(Name, Population, Surface)
RESIDENCE(Id, Surname, Region)
Write a SQL query that returns the regions having
more inhabitants than residents
--idk
SELECT REGION.Name FROM REGION
JOIN RESIDENCE ON RESIDENCE.Region = REGION.Name
GROUP BY REGION.Name
HAVING REGION.Population > COUNT(RESIDENCE.Id)
--other sol
SELECT A.Name FROM REGION AS A,
  (SELECT Region, COUNT(*) as Citizien
   FROM RESIDENCE 
   GROUP BY Region) AS C
  WHERE A.Name = C.Region AND A.Population > C.Citizen

Write a SQL query that returns the titles of those
films produced between 1990 and 2000, having an
average rating greater than or equal to 7.

SELECT F.Title FROM FILM AS F
JOIN RATING AS R ON F.FilmID = R.FilmID
WHERE F.Year >= 1990 AND F.Year <= 2000 
GROUP BY F.FilmID, F.Title
HAVING AVG(R.Rating) >= 7

Write a SQL query that returns the minimum age
of users who rated “Blade Runner” greater than 8.

SELECT MIN(U.Age) FROM
USER AS U, FILM AS F, RATING AS R
WHERE F.Title = "Blade Runner" AND F.FilmID = R.FilmID AND R.Rating > 8 AND R.UserID = U.UserId

Write a SQL query that returns the name of those
playlists having at least one song from an album
published before 2001 by an UMG artist.



