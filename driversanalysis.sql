/**
Exploring Driver data
- top 3 drivers with most wins
- top 3 nationalities for Drivers in F1
- Decade with most successful drivesRS
**/

SELECT * 
FROM DRIVERS

-- add driver ref to results table
ALTER TABLE results
Add driverName Nvarchar(255);

/** add driver reference name to results **/
Update results
Set driverName = dr.driverRef 
From results res 
Inner Join drivers as dr
    On res.driverID = dr.driverID

/** 
data set is incomplete! Hamilton should be #1 with points **/

SELECT COUNT(points) as points, driverName
FROM results
group by driverName
order by COUNT(points) desc

/** nationality of drivers **/

SELECT distinct count(nationality) as numberOfDriverPerCountry, nationality
FROM drivers
group by nationality
order by numberOfDriverPerCountry desc

/** % of drivers nationality that make up Formula 1 **/
CREATE VIEW driverNationality AS
SELECT TOP 5 nationality, count(*) *100.0/sum(count(*)) over() as percentDrivers
FROM drivers
group by nationality
order by percentDrivers desc

/** are there any drivers with the number 0? **/
SELECT *
FROM drivers
WHERE number = '0'

/** nope so let's clean up the null values in number to see how many
drivers are missing numbers **/

UPDATE drivers
SET number = '0'
WHERE number = '\N'

SELECT COUNT(NUMBER)
FROM DRIVERS
WHERE NUMBER = '0'

/** format the DOB column to be just date **/
ALTER TABLE drivers
Add DOBConverted Date;

Update drivers
SET DOBConverted = CONVERT(Date,DOB)

ALTER TABLE drivers
DROP COLUMN dob
/** we can infer from the date that the only driver's with numbers
are those that have recently been in Formula 1. 
Born in the decade 80s - 90s.
We can see this by the DoB and understanding that people enter F1 
around age 18 **/

SELECT driverRef, dobconverted
FROM DRIVERS
WHERE NUMBER != '0'
order by driverRef asc
