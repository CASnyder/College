--==============================================
--Author		: Christopher "Alex" Snyder
--CSU ID		: 2580405
--Created Date	: 29 April 2017 
--File			: lab6.sql 
--Description	: Write triggers and stored procedures
--					for the company database
--==============================================
USE Company;

GO

/*=================================================
Part 1: Triggers and Stored Procedures
=================================================*/

/*
Question 1:
	Before creating any trigger for this lab, Alter Table to Drop all the
	PK, FK, Unique Constraints, Cascade, Check options from the Tables
	Employee and Department for this lab to avoid any possible conflict
	with a system trigger or any table mutating problem. 
*/

ALTER TABLE dbo.Employee DROP CONSTRAINT FK__Employee__DNO__1367E606;
ALTER TABLE dbo.Employee DROP CONSTRAINT FK__Employee__SUPERS__1273C1CD;
ALTER TABLE dbo.Department DROP CONSTRAINT FK__Departmen__MGRSS__145C0A3F;
ALTER TABLE dbo.Dept_Locations DROP CONSTRAINT FK__Dept_Loca__DLOCA__1A14E395;
ALTER TABLE dbo.Project DROP CONSTRAINT FK__Project__DNUM__20C1E124;

/*
Question 2: 

	Write(Create) triggers to implement Constraint EMPDEPTFK in
	Table Employee based on the following rules as defined in DDL for
	Employee as in Figure 4.2:
		FK Dno of Employee On Delete SET DEFAULT (= 1 ) and
		FK Dno of Employee On Update CASCADE of Dnumber PK of
		Department 
*/

--run updates on employee dno when there are updates in the
--department table 
CREATE TRIGGER constraintDEPEMPFK ON dbo.Department FOR 
UPDATE, DELETE
AS
BEGIN

	--i guess this is standard practice for triggers
	SET NOCOUNT ON; 

	--declare some variables
	DECLARE @action char(1);

	--these are specifically
	--for the stored procedure 
	DECLARE @newDno int;
	DECLARE @oldDno int;
	DECLARE @oldName varchar(30);
	DECLARE @newName varchar(30);
	DECLARE @oldMg char(9);
	DECLARE @newMg char(9);


	--fill these variables booooiiiiii
	SELECT @oldDno = d.DNUMBER FROM DELETED d;
	SELECT @newDno = i.DNUMBER FROM INSERTED i; 

	SELECT @oldName = d.DNAME FROM DELETED d;
	SELECT @newName = i.DNAME FROM INSERTED i;

	SELECT @oldMg = d.MGRSSN FROM DELETED d;
	SELECT @newMg = i.MGRSSN FROM INSERTED i;


	--check the type of action 
	--reference:
	--	http://stackoverflow.com/questions/741414/insert-update-trigger-how-to-determine-if-insert-or-update
	SET @action = 'I'; -- Set Action to Insert by default.
    IF EXISTS(SELECT * FROM DELETED)
    BEGIN
        SET @action = 
            CASE
                WHEN EXISTS(SELECT * FROM INSERTED) THEN 'U' -- Set Action to Updated.
                ELSE 'D' -- Set Action to Deleted.       
            END
    END
    ELSE 
        IF NOT EXISTS(SELECT * FROM INSERTED) RETURN; -- Nothing updated or inserted.
	
	--if delete
	IF @action = 'D'
		BEGIN
			UPDATE Employee SET DNO = 1
			FROM Employee e
			JOIN Deleted d ON d.DNUMBER = e.DNO
		
			--procedure outlined in next section
			EXEC SP_Audit_Dept 	
				@tmpDate = null
				, @oldName = @oldName
				, @newName = null
				, @oldNo = @oldDno
				, @newNo = null
				, @oldMgr = @oldMg
				, @newMgr = null; 		
		END
	
	--if update
	IF @action = 'U'
		BEGIN
			UPDATE Employee SET DNO = @newDno
			FROM Employee e
			JOIN Deleted d ON d.DNUMBER = e.DNO

			--procedure outlined in next section
			EXEC SP_Audit_Dept 	
				@tmpDate = null
				, @oldName = @oldName
				, @newName = @newName
				, @oldNo = @oldDno
				, @newNo = @newDno
				, @oldMgr = @oldMg
				, @newMgr = @newMg;  			
		END
		
	
END 

--make sure new employee records only insert
--rows with dno that is in department table 
CREATE TRIGGER constraintEMPDEPTFK ON dbo.EMPLOYEE FOR
INSERT, UPDATE  
AS
BEGIN 
	--various variables
	DECLARE @newDep int;

	--get old and/or new records
	SELECT @newDep = i.DNO FROM INSERTED i;

	--enforce referential integrity
	--in the employee table
	IF @newDep NOT IN (SELECT DNUMBER FROM Department)
		BEGIN
			RAISERROR('No such department number: %i',16,1, @newDep)
			ROLLBACK --aint no rollaback giiirl
		END
END

/*
Question 3: 
	Write (Create) Stored Procedure SP_Audit_Dept that inserts all the
	history of the data of changes by the trigger you created in 1) above into
	a table Audit_Dept_Table. See for the more specific instructions that are
	given in 2 below. 

		1) On Update of the trigger, Insert the new record into a table named 
			Audit_ Dept_Table as follow: 
				date_of_change
				, old_Dname
				, new_Dname
				, old_Dnumber
				, new_Dnumber
				, old_Mgrssn
				, new_Mgrssn
		2) On Delete of the trigger, Insert the changes into Audit_ Dept_Table
		table as well. Since there is no new record for delete, so insert NULL for
		the new record columns:
			 new_Dname
			 , new_Dnumber
			 , new_Mgrssn 
*/

CREATE TABLE dbo.Audit_Dept_Table
(
	Id					int			IDENTITY(1,1) 	
	, Date_Of_Change	date		not null 
	, Old_Dname			varchar(30) not null
	, New_Dname			varchar(30) 
	, Old_Dnumber		int			not null
	, New_Dnumber		int			
	, Old_Mgrssn		char(9)		not null
	, New_Mgrssn		char(9)		

	PRIMARY KEY(Id)
);

/*==============================================
Procedure   : SP_Audit_Dept
Purpose     : insert values into the Audit_Dept_Table table
@tmpDate	: Date of the change; accepts either null or date
@oldName	: old dept name
@newName	: new dept name
@oldNo		: old dept number
@newNo		: new dept number
@oldMgr 	: old dept manager
@newMgr		: new dept manager
==============================================*/
CREATE PROCEDURE SP_Audit_Dept(
	@tmpDate	date
	, @oldName	varchar(30)
	, @newName	varchar(30)
	, @oldNo	int
	, @newNo	int 
	, @oldMgr	char(9)
	, @newMgr	char(9)
)

AS

BEGIN 
DECLARE @changeDate AS date

--check date sent into stored proc
--if it's null use date.today
IF @tmpDate IS NULL
	BEGIN
		SET @changeDate = CONVERT(DATE, GETDATE())
	END  

--if not use the date supplied
ELSE
	BEGIN 
		SET @changeDate = @tmpDate
	END

--trigger will always push a null date
--but i did this in case the proc ever needs to be repurposed

--insert values into audit table
INSERT INTO dbo.Audit_Dept_Table(Date_Of_Change, Old_Dname, New_Dname, Old_Dnumber, New_Dnumber, Old_Mgrssn, New_Mgrssn) VALUES (@changeDate, @oldName, @newName, @oldNo, @newNo, @oldMgr, @newMgr)

END



