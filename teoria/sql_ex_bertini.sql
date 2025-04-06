-- Given the following schema:
--   LECTURER(Id, Surname, Dept)
--   STUDENT(Id, Surname)
--   COURSE(Code, Name)
--   EDITION(Course, Year, Lecturer)
--   EXAM(Student, Course, Year)
-- Write a SQL query that returns the distinct
-- surnames that belong both to students and to
-- lecturers.
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

-- Given the following schema:
--   LECTURER(Id, Surname, Dept)
--   STUDENT(Id, Surname)
--   COURSE(Code, Name)
--   EDITION(Course, Year, Lecturer)
--   EXAM(Student, Course, Year)
-- Write a SQL query that returns the surnames of
-- those lecturers that have taught in courses for
-- which at least 10 students passed the exam.

SELECT DISTINCT L.Surname 
FROM LECTURES AS L, EDITION AS ED, EXAM AS E
WHERE L.Id = ED.id AND E.Course = ED.Course AND E.Year = ED.Year
GROUP BY L.Id, L.Surname, E.Course , E.Year
HAVING COUNT(*) >= 10

-- Given the following schema:
-- TRAIN(Code, Departure, Arrival, Mile)
-- Write a SQL query that returns the minimum and
-- the maximum length of the routes between Boston
-- and Chicago without interchanges.
SELECT MIN(Mile), MAX(Mile) FROM TRAIN
WHERE Departure = "Boston" AND Arrival = "Chicago"


-- Given the following schema:
-- REGION(Name, Population, Surface)
-- RESIDENCE(Id, Surname, Region)
-- Write a SQL query that returns the regions having
-- more inhabitants than residents
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

-- Write a SQL query that returns the titles of those
-- films produced between 1990 and 2000, having an
-- average rating greater than or equal to 7.

SELECT F.Title FROM FILM AS F
JOIN RATING AS R ON F.FilmID = R.FilmID
WHERE F.Year >= 1990 AND F.Year <= 2000 
GROUP BY F.FilmID, F.Title
HAVING AVG(R.Rating) >= 7

-- Write a SQL query that returns the minimum age
-- of users who rated “Blade Runner” greater than 8.

SELECT MIN(U.Age) FROM
USER AS U, FILM AS F, RATING AS R
WHERE F.Title = "Blade Runner" AND F.FilmID = R.FilmID AND R.Rating > 8 AND R.UserID = U.UserId

-- Write a SQL query that returns the name of those
-- playlists having at least one song from an album
-- published before 2001 by an UMG artist.

SELECT Playlist.Name FROM PLAYLIST
JOIN SONG ON Playlist.Song = SONG.ID
JOIN ALBUM ON SONG.Album = ALBUM.Id
JOIN ARTIST ON ALBUM.Artist = ARTIST.Id
WHERE ARTIST.LABELS = "UMG" AND ALBUM.YEAR < 2001 

-- Given the following schema:
--   ACTOR(Id, Name, Year, Nationality)
--   RECITAL(Actor, Film)
--   FILM(Code, Title, Year, Director, Country, Genre)
--   SCREENING(Code, Film, Room, Date, Profits)
--   ROOM(Code, Name, Seats, City)

-- Write a SQL query that returns the title of Fellini's films produced after 1960

SELECT Title FROM FILM
WHERE Director = "Fellini" AND Year > 1960


-- Write a SQL query that returns the title of Japanese
-- science fiction films produced after 1990 or French
-- science fiction films.

SELECT Title FROM FILM
WHERE (Year > 1990 AND Genre = "Sci-Fi" AND Country = "JAPAN") 
      OR (Genre = "Sci-Fi" AND COUNTRY = "French")


-- Write a SQL query that returns the title and the
-- genre of films screened in London on last
-- Christmas Day.

SELECT DISTINCT F.Title, F.Genre 
FROM FILM AS F, SCREENING AS S, ROOM AS R
WHERE F.Code = S.Film AND S.Room = R.Code AND R.City = "London" AND S.Data = "cristhmas"


-- Write a SQL query that returns the number of
-- screening room in London with more than 60 seats.


SELECT COUNT(*) FROM
SCREENING AS S, ROOM AS R,
WHERE S.Room = R.Code AND R.City = "London" AND R.Seats > 60


-- Write a SQL query that returns for each pair of
-- director and actor their names, and the number of
-- films where they have worked together.


SELECT F.Director, A.Name, COUNT(*) AS WorkedTogether
FROM ACTOR AS A, RECITAL AS R, FILM AS F
WHERE A.Id = R.Actor AND F.Code = R.Film
GROUP BY F.Director, A.Name, A.Id


-- Write a SQL query that returns the director and the
-- title of films in which less than 6 actors act.

SELECT F.Director, F.Title 
FROM FILM AS F, RECITAL AS R
WHERE R.Film = F.Code 
GROUP BY F.Code, F.Diretor, F.Title
HAVING COUNT(*) < 6

--Other solution
SELECT F.Director, F.Title
FROM FILM AS F
WHERE 6 < (SELECT COUNT(*)
           FROM RECITAL AS R
           WHERE F.Code = R.Film) 

-- Write a SQL query that returns the name and the whole
-- takings of those rooms in Rome that in January 2005
-- have gained more than $20’000.


SELECT R.Name, SUM(S.Profits) AS Profit
FROM ROOM AS R, SCREENING AS S
WHERE S.Room = R.Code AND S.Date >= "1 jan 2005" AND S.Data <= "31 jan 2005" 
                      AND R.City = "Rome"
GROUP BY R.Name, R.Code
HAVING SUM(S.Profit) > 20.000$


-- Write a SQL query that returns the title of films that
-- have never been screened in Berlin.

SELECT F.Title ,F.Code FROM FILM AS F
WHERE NOT EXISTS (SELECT * FROM
                  SCREENING AS S, ROOM AS R
                  WHERE S.Film = F.Code AND S.Room = R.Code
                  AND R.City = "Berlin")

--other solution
SELECT F.Title, F.Code FROM FILM AS F
WHERE "Berlin" NOT IN (SELECT R.City
                       FROM SCREENING AS S, ROOM AS R
                       WHERE S.Room = R.Code)



-- Write a SQL query that returns the title of films that
-- have never been screened in Berlin.

SELECT F.Title, F.Code
FROM FILM AS S
WHERE NOT EXISTS (SELECT *
                  FROM SCREENING AS S
                  WHERE S.Film = F.Code 
                  AND S.Profits > 500)


-- Write a SQL query that returns the title of films that
-- have always earned more than $500 in all their
-- screening.

SELECT F.Title, F.Code 
FROM FILM AS F
WHERE 500 <= (SELECT MIN(S.Profits)
              FROM SCREENING AS S
              WHERE S.Film = F.Code
              )


--One More Schema
--  MUSEUM(Name, City)
--  ARTIST(Name, Nationality)
--  WORK(Code, Title, NameM, NameA)
--  CHARACTER(Name, CodeW)

--Write a SQL query that returns the name of the
--museums in London that do not have Tiziano's
--works

SELECT M.Name 
FROM MUSEUM AS M 
WHERE M.City = "London" AND NOT EXISTS
                (SELECT * FROM 
                 WORK AS W 
                 WHEREW.NameM = M.Name AND W.NameA = "Tiziano")

--Write a SQL query that returns the name of the
--museums in London that only have Tiziano's works.
SELECT M.Name
FROM MUSEUM AS M
WHERE M.City = "LONDON" AND "Tiziano" = ALL(
                                        SELECT W.NameA FROM WORK AS W
                                        WHERE W.NameM = M.Code)

-- Write a SQL query that returns the name of the
-- museums that have at least 20 works by Italian
-- artists.
SELECT M.Name
FROM WORK AS W, ARTIST AS A
WHERE A.Nationality = "Italy" AND A.Name = W.NameA
GROUP BY W.NameM
HAVING COUNT(*) > 20


-- Another schema
  --CARS(Plate, Brand, Power, Owner, CodeIns)
  --OWNERS(Code, Name, Residence)
  --INSURANCES(CodeIns, Name, Hq)
  --ACCIDENT(CodeAcc, Location, Date)
  --INVOLVEDCARS(CodeAcc, Plate, AmountDamage)

-- Write a SQL query that returns the plate and name
-- of the owner of BMW cars or with more than 120hp,
-- insured with "AVIVA".

SELECT C.Plate, O.Name
FROM CARS AS C, OWNERS AS O, INSURANCES AS I
WHERE C.Owner = O.Code AND I.CodeIns = C.CodeIns 
      AND I.Name = "AVIVA" AND (C.Brand ="bmw" or C.Power > 120)


--Write a SQL query that returns for each insurance,
--the name, location, and number of cars insured.

SELECT I.Name, I.Hq, COUNT(*) AS CarsInsured
FROM INSURANCES AS I, CARS AS C
WHERE I.CodeIns = C.CodeIns 
GROUP BY I.Name, I.Hq

-- Write a SQL query that returns for each car
-- involved in more than one crash, the plate, the
-- insurance name and the total damages reported.

SELET C.Plate, I.Name, SUM(IN.AmountDamage) AS TotalDamage
FROM CARS AS C, INVOLVEDCARS AS IN, INSURANCES AS I
WHERE C.Plate = I.Plate AND C.CodeIns = I.CodeIns  
GROUP BY C.Plate, I.Name
HAVING COUNT(*) > 1

--Write a SQL query that returns the plate of cars that
--were not involved in crashes after 04/05/2020.

SELECT C.Plate
FROM CARS AS C
WHERE NOT EXISTS (SELECT *
                  FROM ACCIDENT AS A, INVOLVEDCARS AS I
                  WHERE A.CodeAcc = I.CodeAcc AND I.Plate = C.Plate
                  AND A.Date > "04/05/2020"
                 )

--Write a SQL query that returns the accidents code
--in which cars with less than 90hp were not
--involved.
SELECT I.CodeAcc 
FROM INVOLVEDCARS AS I
WHERE 90  <= ALL (SELECT C.Power
              FROM CARS AS C,INVOLVEDCARS AS IN
              WHERE C.Plate = IN.Plate
              AND I.CodeAcc = IN.CodeAcc
             ) 

--Write a SQL query that returns the code and name
--of those who own more than one car.
SELECT O.Code, O.Name
FROM OWNERS AS O, CARS AS C
WHERE C.Owner = O.Code 
GROU BY O.Code, O.Name
HAVING COUNT(*) > 1


--Last schema (i hope)
--NOVEL(CodeNov, Title, Author, Year)
--CHARACTERS(Name, CodeNov, Gender, Role)
--AUTHORS(Name, YearB, YearD, Country)
--FILM(Code, Title, Director, Producer,
--Year, Novel)
SELECT C.Name, COUNT(*) AS AppearanceNumber
FROM CHARACTERS AS C, NOVEL S N
WHERE N.CodeNov = C.CodeNov
GROUP BY C.Name
HAVING COUNT(*) > 1

--Write a SQL query that returns the title of the italian
--novels from which more than one film has been
--made.
SELECT N.Title 
FROM NOVEL AS N, AUTHORS AS A, FILM AS F 
WHERE N.Author = A.Name AND A.Country "Italy" AND F.Novel = N.CodeNov
GROUP BY N.CodeNov, N.Title
HAVING COUNT(*) > 1

--Write a SQL query that returns the title of the
--novels from which no films were derived.
SELECT N.Title 
FROM NOVEL AS N 
WHERE NOT EXIST (
                SELECT *
                FROM FILM AS F
                WHERE F.Novel = N.CodeNov)

--Write a SQL query that returns the title of novels
--whose main characters are all female.
SELECT N.Title, N.CodeNov
FROM NOVEL AS N
WHERE "F" = ALL(SELECT C.GENDER
                FROM CHARACTERS AS C
                WHERE N.CodeNov = C.CodeNov)
