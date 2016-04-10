USE CrewManifest

-- List of all dead.
GO
SELECT *
FROM tblCrewMember
WHERE TimeOfDeath IS NOT NULL OR
CauseOfDeathID IS NOT NULL

-- List of add dead showing name, rank, department, planet, gender and race.
GO
SELECT CONCAT(cm.FIRSTNAME, COALESCE(' ' + cm.MIDDLENAME, ''), ' ', cm.LASTNAME) AS [Full Name],
ra.[Rank],
d.Department,
p.Planet,
g.Gender,
r.Race
FROM tblCrewMember AS cm
INNER JOIN tblRank AS ra ON ra.RankID = cm.RankID
INNER JOIN tblPlanet AS p ON p.PlanetID = cm.PlanetID
INNER JOIN tblGender AS g ON g.GenderID = cm.GenderID
INNER JOIN tblRace AS r ON r.RaceID = cm.RaceID
INNER JOIN tblCrewMember_dept AS cd ON cd.CrewID = cm. CrewID
INNER JOIN tblDepartment as d ON d.DeptID = cd.DeptID

-- Showing all dead crewmembers, the cause of their demise and at what time this occured.
GO
SELECT CONCAT(cm.FIRSTNAME, COALESCE(' ' + cm.MIDDLENAME, ''), ' ', cm.LASTNAME) AS [Full Name],
cod.CauseOfDeath,
cm.TimeOfDeath

FROM tblCrewMember AS cm
INNER JOIN tblCauseOfDeath AS cod ON cod.CauseOfDeathID = cm.CauseOfDeathID
WHERE cm.CauseOfDeathID IS NOT NULL OR
cm.TimeOfDeath IS NOT NULL

--Showing all dead with the rank of captain that earn more than 50000.
GO
SELECT CONCAT(cm.FIRSTNAME, COALESCE(' ' + cm.MIDDLENAME, ''), ' ', cm.LASTNAME) AS [Full Name],
cm.Salary
FROM tblCrewMember AS cm
INNER JOIN tblRank AS r ON cm.RankID = r.RankID
WHERE [Rank] = 'Captain' AND Salary >= 50000 AND
TimeOfDeath IS NOT NULL

-- All dead from planet earth.
GO
SELECT CONCAT(cm.FIRSTNAME, COALESCE(' ' + cm.MIDDLENAME, ''), ' ', cm.LASTNAME) AS [Full Name],
Planet
FROM tblCrewMember AS cm
INNER JOIN tblPlanet AS p ON cm.PlanetID = p.PlanetID
WHERE TimeOfDeath IS NOT NULL AND Planet = 'Earth'

-- All dead between two dates. Shows names and dates.
GO
SELECT CONCAT(cm.FIRSTNAME, COALESCE(' ' + cm.MIDDLENAME, ''), ' ', cm.LASTNAME) AS [Full Name],
TimeOfDeath
FROM tblCrewMember AS cm
WHERE TimeOfDeath IS NOT NULL AND
(TimeOfdeath >= '2080-01-01' AND TimeOfDeath < '2080-04-02')
ORDER BY TimeOfDeath, FirstName

-- The number of deaths of each rank.
GO
SELECT [Rank],
COUNT([Rank]) AS [Number of casualties]
FROM tblCrewMember AS cm
INNER JOIN tblRank AS r ON cm.RankID = r.RankID
WHERE TimeOfDeath IS NOT NULL
GROUP BY [RANK]

-- Show the one with the highest wage of everyone aboard the ship.

SELECT CONCAT(cm.FIRSTNAME, COALESCE(' ' + cm.MIDDLENAME, ''), ' ', cm.LASTNAME) AS [Full Name],
Salary
FROM tblCrewMember AS cm
WHERE SALARY = (SELECT MAX(Salary) FROM tblCrewMember)

-- Group all crewmembers by cause of death.
SELECT cd.CauseOfDeath, 
CONCAT(cm.FIRSTNAME, COALESCE(' ' + cm.MIDDLENAME, ''), ' ', cm.LASTNAME) AS [Full Name]
FROM tblCrewMember AS cm
INNER JOIN tblCauseOfDeath AS cd ON cm.CauseOfDeathID = cd.CauseOfDeathID
GROUP BY cd.CauseOfDeath, cm.FirstName, cm.MiddleName, cm.LastName

/*
The salary average of all crew members.
It gets ridiculously high. 
But that is what happens when you have Bruce Wayne on your crew.
*/

SELECT (SUM(Salary)) / (COUNT(*)) AS [Average Salary]
FROM tblCrewMember
