/**
- Altered the table to add information such as status, driver ref
and constructor refs
- got the number of pole, second, and third wins by team

**/

-- add new sprint results column to add in status
ALTER TABLE sprint_results
Add sprintStatus Nvarchar(255);

-- Add driver name

ALTER TABLE sprint_results
Add driverName Nvarchar(255);

-- add constructor name
ALTER TABLE sprint_results
Add conName Nvarchar(255);


/** updating sprintStatus column with text  **/

Update sprint_results
Set sprintStatus = db.status 
From sprint_results sp 
Inner Join statusDB as db
    On sp.statusID = db.statusID
/** add driver reference name to sprint results **/
Update sprint_results
Set driverName = dr.driverRef 
From sprint_results sp 
Inner Join drivers as dr
    On sp.driverID = dr.driverID

/** count the number of sprint wins by constructor  to see
if more sprint wins increased constructor wins **/

SELECT COUNT(position) as sprintWins, constructorID as constructorID
FROM sprint_results 
WHERE position = 1
GROUP BY constructorID

/** add con names **/

Update sprint_results
Set conName = con.constructorRef 
From sprint_results sp 
Inner Join constructors as con
    On sp.constructorID = con.constructorID

/** count sprint wins and add constructor name now that we have it**/
/** since sprints debuted in July 2021, there have been 5 with only 2 winners **/

CREATE VIEW constructorWins AS
SELECT conName,
    sum(case when position = 1 then 1 else 0 end) AS pole,
    sum(case when position = 2 then 1 else 0 end) AS second,
	sum(case when position = 3 then 1 else 0 end) AS third
FROM sprint_results
GROUP BY conName

/**
points by con **/
SELECT conName, sum(points)
FROM sprint_results
Group by conName
