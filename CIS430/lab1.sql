--==============================================
--Author		: Christopher "Alex" Snyder
--CSU ID		: 2580405
--Created Date	: 1 February 2017 
--File			: CIS430Lab1.sql 
--Description	: Creates Company database with two tables:
--					-Employee
--					-Department
--==============================================
CREATE Database Company;
Go
Use Company;

--==================================
--Table: Employee
--==================================
CREATE TABLE dbo.Employee 
(
	FNAME varchar(15) not null
	, MINIT char not null
	, LNAME	varchar(15) not null
	, SSN char(9) not null
	, BDATE date not null
	, ADDRESS varchar(30) not null
	, SEX char not null
	, SALARY decimal(10,2) not null
	, SUPERSSN char(9) 
	, DNO int not null 

	PRIMARY KEY (SSN)
);


--==================================
--Table: Department
--==================================
CREATE TABLE dbo.Department 
(
	DNAME varchar(30) not null
	, DNUMBER int not null 
	, MGRSSN char(9) not null 
	, MGRSTARTDATE date 

	PRIMARY KEY (DNUMBER)
);


--insert employee records
INSERT INTO EMPLOYEE VALUES('John','B','Smith','123456789','9-Jan-55','731 Fondren, Houston, TX','M',30000,'987654321',5); 
INSERT INTO EMPLOYEE VALUES('Franklin','T','Wong','333445555','08-Dec-45','638 Voss, Houston, TX','M',40000,'888665555',5); 
INSERT INTO EMPLOYEE VALUES('Joyce','A','English','453453453','1-Jul-62','5631 Rice, Houston, TX','F',25000,'333445555',5); 
INSERT INTO EMPLOYEE VALUES('Ramesh','K','Narayan','666884444','15-Sep-52','975 Fire Oak, Humble, TX','F',38000,'333445555',5); 
INSERT INTO EMPLOYEE VALUES('James','E','Borg','888665555','10-Nov-27','450 Stone, Houston, TX','M',55000,null,1); 
INSERT INTO EMPLOYEE VALUES('Jennifer','S','Wallace','987654321','20-Jun-31','291 Berry, Bellaire, TX','F',43000,'888665555',4); 
INSERT INTO EMPLOYEE VALUES('Ahmad','V','Jabar','987987987','29-Mar-59','980 Dallas, Houston, TX','M',25000,'987654321',4); 
INSERT INTO EMPLOYEE VALUES('Alicia','J','Zelaya','999887777','19-Jul-58','3321 Castle, Spring, TX','F',25000,'987654321',4); 

--insert department records
INSERT INTO DEPARTMENT VALUES ('Headquarters','1','888665555','19-Jun-71');
INSERT INTO DEPARTMENT VALUES ('Administration','4','987654321','01-Jan-85');
INSERT INTO DEPARTMENT VALUES ('Research','5','333445555','22-May-78');
INSERT INTO DEPARTMENT VALUES ('Automation','7','123456789','06-Oct-05');



