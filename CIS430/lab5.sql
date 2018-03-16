--==============================================
--Author		: Christopher "Alex" Snyder
--CSU ID		: 2580405
--Created Date	: 10 April 2017 
--File			: lab5.sql 
--Description	: Create views for the company database
--==============================================
USE Company;

GO

/*=================================================
Part 1: Views
=================================================*/

/*
1-1) Create a view named VDept_Headcount that reports headcount for each department.
	The report includes 3 columns as follow:
		Dept_Name
		, Dept_Number
		, No_Emp.
	Include all the departments.
Show the content of the view through SQL (Select * from VDept_Headcount;)
*/

CREATE VIEW VDept_Headcount AS 
SELECT
	d.DNAME as Dept_Name
	, d.DNUMBER as Dept_Number
	, COUNT(e.SSN) as No_Emp
FROM 
	Department d
	LEFT JOIN Employee e on e.DNO = d.DNUMBER
GROUP BY 
	d.DNUMBER
	, d.DNAME;
SELECT * FROM VDept_Headcount;

/*
1-2)
Add yourself to the database (to Employee table). Then Show the content of your view again to
see if your view is updated according to the changes in its base table Employee. 
*/

--insert myself 
--give myself a modest starting salary
--(recycled this joke from lab 2)
INSERT INTO dbo.Employee VALUES('Christopher','A','Snyder II','121212129','9-Jun-94','124 Conch St, Sugarland, TX','M', 85000,'123456789',7);
SELECT * FROM VDept_Headcount;

/*
1-3)
Then Change your view to add two more pieces of information – Sum_Salary, Ave_Salary for each department. Include all
the departments. Your report (view) lists 5 Columns as follows:
Dept_Name, Dept_Number, No_Emp, Sum_Salary, Ave_Salary 
*/

ALTER VIEW VDept_Headcount AS
SELECT
	d.DNAME as Dept_Name
	, d.DNUMBER as Dept_Number
	, COUNT(e.SSN) as No_Emp
	, SUM(e.SALARY) as Sum_Salary
	, AVG(e.SALARY) as Avg_Salary
FROM 
	Department d
	LEFT JOIN Employee e on e.DNO = d.DNUMBER
GROUP BY 
	d.DNUMBER
	, d.DNAME;
SELECT * FROM VDept_Headcount;

/*=================================================
Part 2: Stored Procedures using Cursors
=================================================*/

/*

Write a Stored Procedure SP_Report_NEW_Budget using the view created in
Part 1-3). 

Stored Procedure SP_Report_ NEW_Budget does the following tasks:
Creates a new table NEW_Dept_Budget as follow:
	NEW_Dept_Budget has 5 columns
		Dept_No (Int)
		Dept_Name (Char(30))
		COUNT_Emp (INT)
		New_SUM_Salary (INT)
		New_AVE_Salary (INT)

2-1) Check if the view VDept_Budget is empty or not (by counting rows from the view).
2-2) If not empty , For each row of the view VDept_Budget, Calculate New_SUM_Salary,
	New_AVE_Salary as follow:
	If Dept = 1, Increase SUM(salary) 10%
	If Dept = 4, Increase SUM(salary) 20%
	If Dept = 5, Increase SUM(salary) 30%
	If Dept = 7, Increase SUM(salary) 40%
2-3) Insert each column value into the new table NEW_Dept_Budget. 

REFERENCES: 
	http://stackoverflow.com/questions/28747859/oracle-pl-sql-creating-tables-in-cursor
	https://www.aspsnippets.com/Articles/Using-Cursor-in-SQL-Server-Stored-Procedure-with-example.aspx
	https://docs.microsoft.com/en-us/sql/t-sql/functions/fetch-status-transact-sql
	http://www.sqlservergeeks.com/simple-cursor-in-sql-server-to-insert-records/
	http://stackoverflow.com/questions/1687988/if-else-stored-procedure

Literally the most references I've ever needed to finish a DB assignment so far.
*/

CREATE PROCEDURE SP_Report_NEW_Budget
AS

BEGIN
--create a temporary table 
CREATE TABLE #NEW_Dept_Budget 
(
	Dept_No int
	, Dept_Name char(30)
	, COUNT_Emp int 
	, New_SUM_Salary int
	, New_AVE_Salary int
) 

--various variables
DECLARE @depno as int 
DECLARE @depname as char(30)
DECLARE @depemps as int  
DECLARE @oldSum as decimal(10,2) 
DECLARE @oldAvg as decimal(10,2) 
DECLARE @newSum as int 
DECLARE @newAvg as int   

DECLARE reportCursor CURSOR
FOR 
SELECT Dept_Number, Dept_Name, No_Emp, Sum_Salary, Avg_Salary
FROM VDept_Headcount 


OPEN reportCursor
FETCH NEXT FROM reportCursor INTO @depno, @depname, @depemps, @oldSum, @oldAvg;

--for each row in the tuple 
--do the things
WHILE @@FETCH_STATUS = 0
BEGIN
	
	--calculate the increase

	--If Dept = 1, Increase SUM(salary) 10%
	IF @depno = 1 
		BEGIN 
			SET @newSum = @oldSum * 1.1
			SET @newAvg = @oldAvg * 1.1
		END
	
	--If Dept = 4, Increase SUM(salary) 20%
	IF @depno = 4
		BEGIN 
			SET @newSum = @oldSum * 1.2
			SET @newAvg = @oldAvg * 1.2
		END
	
	--If Dept = 5, Increase SUM(salary) 30%
	IF @depno = 5
		BEGIN
			SET @newSum = @oldSum * 1.3 
			SET @newAvg = @oldAvg * 1.3
		END
	
	--If Dept = 7, Increase SUM(salary) 40%
	IF @depno = 7
		BEGIN
			SET @newSum = @oldSum * 1.4
			SET @newAvg = @oldAvg * 1.4
		END

	--insert into ye olde new budget table 
	INSERT INTO #NEW_Dept_Budget VALUES (@depno, @depname, @depemps, @newSum, @newAvg)
	FETCH NEXT FROM reportCursor INTO @depno, @depname, @depemps, @oldSum, @oldAvg
END 

SELECT * FROM #NEW_Dept_Budget
CLOSE reportCursor
DEALLOCATE reportCursor

END