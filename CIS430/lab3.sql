--==============================================
--Author		: Christopher "Alex" Snyder
--CSU ID		: 2580405
--Created Date	: 2 March 2017 
--File			: lab3.sql 
--Description	: Query the relational company database
--					-add myself to the database and retrieve
--						info related to employee, dependent, and works_on
--					- write SQL select statements to retrieve data in:
--						1) name and address of all the female managers
--						2) list of all project numbers for projects
--							that involve an employee whose last name is smith
--						3) name and address and department of the highest
--							ranked employee
--						4) list all employees in each department ordered by
--							the department number and name
--						5) names of managers who have no dependents
--==============================================
USE Company;
GO


--insert myself 
--give myself a modest starting salary
INSERT INTO dbo.Employee VALUES('Christopher','A','Snyder','787560023','9-Jun-94','124 Conch St, Sugarland, TX','M', 75000,'333445555',5);

--insert the projects i work on
--making sure to give myself a number of work hours
--that accurately reflects my stellar work ethic
INSERT INTO dbo.Works_On VALUES('787560023','2','300');
INSERT INTO dbo.Works_On VALUES('787560023','10','700');

--give myself some dependents
--aka time to fake marry my current
--celebrity crush because that's not a weird
--thing to do on an assignment
-- ...
--Actor Justice Smith if you read GitHub comments hit me up 
INSERT INTO dbo.Dependent VALUES('787560023','Justice','M','9-Aug-95','Spouse');


--select all my new values with a single query
SELECT *
FROM 
	dbo.Employee em
	INNER JOIN dbo.Works_On		wo on wo.ESSN = em.SSN
	INNER JOIN dbo.Dependent	de on de.ESSN = em.SSN
WHERE
	em.SSN = '787560023';

--===================================================================

/*
Question 1
Retrieve the name and address of all the female managers. 
*/
SELECT
	em.FNAME
	, em.MINIT
	, em.LNAME
	, em.ADDRESS
FROM
	Department de
	INNER JOIN Employee em on de.MGRSSN = em.SSN
WHERE
	em.SEX='F';

--===================================================================

/*
Question 2
Make a list of all project numbers for projects that involve an employee whose last
name is ‘Smith’, either as a worker or as a manager of the department that controls the
project.
*/

SELECT
	pr.PNUMBER
FROM
	Project pr
	INNER JOIN Employee em		on pr.DNUM = em.DNO
WHERE
	em.LNAME = 'Smith'
	OR pr.DNUM in (
		SELECT	de.DNUMBER
		FROM	Department de
				INNER JOIN Employee em on de.MGRSSN = em.SSN 
		WHERE	em.LNAME = 'Smith'
	); 


--===================================================================

/*
Question 3
Retrieve the name and address and his/her department name of the highest ranked
employee who does not report to anybody in the company. 
*/

SELECT 
	em.FNAME
	, em.MINIT
	, em.LNAME
	, em.ADDRESS
	, de.DNAME
FROM
	Employee em
	INNER JOIN Department de on em.SSN = de.MGRSSN
WHERE 
	em.SUPERSSN is null;

--===================================================================

/*
Question 4
For each department, list all the employees who are working in the department with
the employee’s first and last name and first and last name of his or her immediate
supervisor. List the result in the order of each department number and department
name.
Extra points: Include all the employees who do not have any supervisor as well in
the list.
*/


SELECT
	de.DNUMBER as 'Department Number'
	, de.DNAME as 'Department Name'
	, em.FNAME + ' ' + em.LNAME as 'Employee'
	, mgr.FNAME + ' ' + mgr.LNAME as 'Direct Supervisor'

FROM
	Department de
	INNER JOIN Employee em on de.DNUMBER = em.DNO
	LEFT OUTER JOIN Employee mgr on mgr.SSN = em.SUPERSSN
ORDER BY 
	de.DNUMBER ASC;

--===================================================================

/*
Question 5
List the name of managers who have no dependents.
*/
SELECT 
	em.FNAME
	, em.MINIT
	, em.LNAME
FROM
	Employee em
WHERE
	em.SSN in (
			SELECT MGRSSN
			FROM Department 
			)

	AND

	em.SSN not in (
			SELECT ESSN
			FROM Dependent
			);
