--==============================================
--Author		: Christopher "Alex" Snyder
--CSU ID		: 2580405
--Created Date	: 4 April 2017 
--File			: lab4.sql 
--Description	: Query the relational "Company" database
--					Using "HAVING" and aggregate functionse
--==============================================
USE Company;
GO

/*=================================================
Part 1: Update the following new changes into the database:
-Joyce English got hitched
-Jennifer Wallace had (or found) a baby
-Jennifer Wallace got a new project to work on
=================================================*/

/*
Joyce English with Ssn = 453453453 got married with Joe Anderson.
But first
I will alter the Employee table for the sake of this joke I'm about to make 
*/
ALTER TABLE dbo.Employee ALTER COLUMN LNAME varchar(30)

--She decided to go with a hyphenated last name because she's a modern woman
UPDATE dbo.Employee SET LNAME = 'English-Anderson' WHERE SSN = '453453453';

--she's a cancer and those people typically marry like
--scorpios which....good luck, girl
INSERT INTO dbo.Dependent VALUES('453453453','Joe', '18-Nov-1960', 'Spouse');

--Jenifer Wallace with Ssn = 987654321 just had a new daughter named Erica.
INSERT INTO dbo.Dependent VALUES('987654321', 'Erica', 'F','4-Apr-17', 'Daughter');

--Jenifer Wallace with Ssn = 987654321 is just assigned to a new project 
--number ‘10’ to work on with 0 initial hours.
INSERT INTO dbo.Project VALUES('ProjectJ','10','Stafford','4'); --(the j is for jen)
INSERT INTO dbo.Works_On VALUES('987654321','10',0);

--A lot of big things are happening for Jennifer Wallace
--But what heartless jerk dumped her on a project right after she had a baby?

--verify specific records
SELECT * FROM dbo.Employee WHERE SSN = '453453453';
SELECT * FROM dbo.Dependent WHERE ESSN = '987654321' or ESSN = '453453453';
SELECT * FROM dbo.Works_On WHERE PNO = '10';

--verify entire table
SELECT * FROM Works_On;
SELECT * FROM Dependent;

/*=================================================
Part 2: Write SQL Queries to grab the following
1A - employees in each department
1B - employees in each department (with a twist!)
2 - married women who work on 3 or more projects
3 - employees who work in R&D and are married but 
	don't have kids
4 - married employees who only have daughters
5 - employees who work on any projects where there
	are more women on the project than men
=================================================*/

/*
Q1:
For each department, list all the employees who are working in the department with the
employee’s first and last name and first and last name of his or her immediate supervisor. Include
all the departments and all the employees who do not have any supervisor. List the result in the
order of each department number and first name of each employee. 
*/

SELECT
	de.DNUMBER as 'Department Number' 
	, de.DNAME as 'Department'
	, e.FNAME as 'Employee First Name'
	, e.LNAME as 'Employee Last Name'
	, mgr.FNAME as 'Manager First Name'
	, mgr.LNAME as 'Manager Last Name'
FROM
	dbo.Department de 
	LEFT OUTER JOIN dbo.Employee e on de.DNUMBER = e.DNO
	LEFT OUTER JOIN dbo.Employee mgr ON mgr.SSN = e.SUPERSSN
ORDER BY
	de.DNUMBER
	,  e.FNAME;
/*
Different version of Q1:
Q1_1: List the same information as Q1 with a change: List all the employees who do not have any
supervisor but do not list the departments that no employee is working for in the output. 
*/

SELECT
	de.DNUMBER as 'Department Number' 
	, de.DNAME as 'Department'
	, e.FNAME as 'Employee First Name'
	, e.LNAME as 'Employee Last Name'
	, mgr.FNAME as 'Manager First Name'
	, mgr.LNAME as 'Manager Last Name'
FROM
	dbo.Department de 
	INNER JOIN dbo.Employee e on de.DNUMBER = e.DNO
	LEFT OUTER JOIN dbo.Employee mgr ON mgr.SSN = e.SUPERSSN
ORDER BY
	de.DNUMBER
	,  e.FNAME;

/*
Q2:
Get SSN and the last name of married female employees who work on three or more projects 
*/

SELECT
	e.SSN
	, e.LNAME
	, COUNT(DISTINCT CONCAT(wo.ESSN, wo.PNO)) as 'Number of Projects'
FROM 
	dbo.Employee e
	INNER JOIN dbo.Dependent de ON e.SSN = de.ESSN
	LEFT OUTER JOIN dbo.Works_On wo ON e.SSN = wo.ESSN
WHERE 
	e.SEX = 'F'
	AND de.RELATIONSHIP = 'Spouse'
GROUP BY
	e.SSN
	, e.LNAME
HAVING COUNT(DISTINCT CONCAT(wo.ESSN, wo.PNO)) >= 3;

/*
Q3:
List the name of employees who is working for ‘Research’ department and are married but have
no children. 
*/
SELECT
	e.FNAME
	, e.LNAME
FROM 
	dbo.Employee e
	INNER JOIN dbo.Dependent dpd ON e.SSN = dpd.ESSN
	INNER JOIN dbo.Department dpt on e.DNO = dpt.DNUMBER
WHERE 
	dpt.DNAME = 'Research'
	AND dpd.RELATIONSHIP = 'Spouse'
	AND e.SSN NOT IN (
		SELECT ESSN
		FROM dbo.Dependent
		WHERE RELATIONSHIP = 'Son' OR RELATIONSHIP = 'Daughter'); 	

/*
Q4:
Get the last name of married employees who only have daughters. 
*/
SELECT 
	e.FNAME
	, e.LNAME
FROM 
	dbo.Employee e
WHERE 
	e.SSN IN (
		SELECT D1.ESSN
		FROM dbo.Dependent D1
		WHERE D1.RELATIONSHIP = 'Spouse'
	)

	AND e.SSN IN (
		SELECT D2.ESSN 
		FROM dbo.Dependent D2
		WHERE D2.RELATIONSHIP = 'Daughter'
	)

	AND e.SSN NOT IN (
		SELECT D3.ESSN
		FROM dbo.Dependent D3
		WHERE D3.RELATIONSHIP = 'Son'
	);

/*
Q5:
Give the last name and ssn of those employees who work in any project(s) where there
are more female than male employees. 

From Alex: I added the counts of men and women just to make sure the numbers
made sense
*/

SELECT 
	e.SSN
	, e.LNAME
	, COUNT(men.SSN) as 'MEN'
	, COUNT(women.ssn) as 'WOMEN'
FROM
	Works_On wo
	INNER JOIN Employee e ON e.SSN = wo.ESSN 
	LEFT JOIN (SELECT e1.SSN FROM Employee e1 WHERE e1.SEX = 'M') AS men ON men.SSN = wo.ESSN
	LEFT JOIN (SELECT e2.SSN FROM Employee e2 WHERE e2.SEX = 'F') AS women ON women.SSN = wo.ESSN
GROUP BY
	e.SSN
	, e.LNAME
HAVING COUNT(women.SSN) > COUNT(men.SSN);