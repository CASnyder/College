--==============================================
--Author		: Christopher "Alex" Snyder
--CSU ID		: 2580405
--Created Date	: 22 February 2017 
--File			: lab2.sql 
--Description	: Update company database with new tables
--					- dept locations
--					- project
--					- works on
--					- dependent
--==============================================
USE Company;

--===================================================
--================ Create new tables=================
--===================================================

--==================================
--Table: Dependent
--==================================
CREATE TABLE dbo.Dependent 
(
	ESSN				char(9)			not null
	, DEPENDENT_NAME	nvarchar(15)	not null
	, SEX				char			not null
	, BDATE				date			not null
	, RELATIONSHIP		nvarchar(15)	not null

	PRIMARY KEY (ESSN, DEPENDENT_NAME)
	FOREIGN KEY (ESSN) REFERENCES dbo.Employee(SSN)
);


--==================================
--Table: Dept_Locations
--==================================
CREATE TABLE dbo.Dept_Locations 
(
	DNUMBER		int				not null
	, DLOCATION	nvarchar(15)	not null
	
	PRIMARY KEY (DNUMBER, DLOCATION)
	FOREIGN KEY (DNUMBER) REFERENCES dbo.Department(DNUMBER)
);

--==================================
--Table: Project
--==================================
CREATE TABLE dbo.Project 
(
	PNAME		nvarchar(15)	not null
	, PNUMBER	int				not null
	, PLOCATION	nvarchar(15)	not null
	, DNUM		int			not null

	PRIMARY KEY (PNUMBER)
	FOREIGN KEY (DNUM) REFERENCES dbo.Department(DNUMBER)
);

--==================================
--Table: WORKS_ON
--==================================
CREATE TABLE dbo.Works_On 
(
	ESSN		char(9)			not null
	, PNO		int				not null
	, [HOURS]	decimal(10,1)	
	
	PRIMARY KEY (ESSN, PNO)
	FOREIGN KEY (ESSN) REFERENCES dbo.Employee(SSN)
	, FOREIGN KEY (PNO) REFERENCES dbo.Project(PNUMBER)
);

--===================================================
--==============Alter Existing Tables================
--===================================================
ALTER TABLE dbo.Employee ADD
	FOREIGN KEY (SUPERSSN)  REFERENCES dbo.Employee(SSN)
	, FOREIGN KEY (DNO) REFERENCES dbo.Department(DNUMBER)

ALTER TABLE dbo.Department ADD
	FOREIGN KEY (MGRSSN) REFERENCES dbo.Employee(SSN)


--===================================================
--===========Populate Tables with Values=============
--===================================================

--dept locations
INSERT INTO Dept_Locations VALUES('1', 'Houston');
INSERT INTO Dept_Locations VALUES('4', 'Stafford');
INSERT INTO Dept_Locations VALUES('5', 'Bellaire');
INSERT INTO Dept_Locations VALUES('5', 'Sugarland');
INSERT INTO Dept_Locations VALUES('5', 'Houston');

--project
INSERT INTO Project VALUES('ProductX','1','Bellaire','5');
INSERT INTO Project VALUES('ProductY','2','Sugarland','5');
INSERT INTO Project VALUES('ProductZ','3','Houston','5');
INSERT INTO Project VALUES('Computerization','10','Stafford','4');
INSERT INTO Project VALUES('Reorganization','20','Houston','1');
INSERT INTO Project VALUES('Newbenefits','30','Stafford','4');

--dependent
INSERT INTO dbo.Dependent VALUES('123456789','Alice','F','31-Dec-78','Daughter');
INSERT INTO dbo.Dependent VALUES('123456789','Elizabeth','F','05-May-57','Spouse');
INSERT INTO dbo.Dependent VALUES('123456789','Michael','M','01-Jan-78','Son');
INSERT INTO dbo.Dependent VALUES('333445555','Alice','F','05-Apr-76','Daughter');
INSERT INTO dbo.Dependent VALUES('333445555','Joy','F','03-May-48','Spouse');
INSERT INTO dbo.Dependent VALUES('333445555','Theodore','M','25-Oct-73','Son');
INSERT INTO dbo.Dependent VALUES('987654321','Abner','M','29-Feb-32','Spouse');

--works on
INSERT INTO Works_On VALUES('123456789','1',32.5);
INSERT INTO Works_On VALUES('123456789','2',7.5);
INSERT INTO Works_On VALUES('333445555','2',10);
INSERT INTO Works_On VALUES('333445555','3',10);
INSERT INTO Works_On VALUES('333445555','10',10);
INSERT INTO Works_On VALUES('333445555','20',10);
INSERT INTO Works_On VALUES('453453453','1',20);
INSERT INTO Works_On VALUES('453453453','2',20);
INSERT INTO Works_On VALUES('888665555','20',null);
INSERT INTO Works_On VALUES('987654321','20',15);
INSERT INTO Works_On VALUES('987654321','30',20);
INSERT INTO Works_On VALUES('987987987','10',35);
INSERT INTO Works_On VALUES('987987987','30',5);
INSERT INTO Works_On VALUES('999887777','10',10);
INSERT INTO Works_On VALUES('999887777','30',30);
