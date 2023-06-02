------------------------
--INSERT INTO SELECT
------------------------
USE AdventureWorks
GO
----Create TestTable
CREATE TABLE TestTable (FirstName VARCHAR(100), LastName VARCHAR(100))
----INSERT INTO TestTable using SELECT
INSERT INTO TestTable (FirstName, LastName)
SELECT FirstName, LastName
FROM Person.Contact
WHERE EmailPromotion = 2
----Verify that Data in TestTable
SELECT FirstName, LastName
FROM TestTable
----Clean Up Database
DROP TABLE TestTable
GO





----------------
--SELECT INTO
----------------
USE AdventureWorks
GO
----Create new table and insert into table using SELECT INSERT
SELECT FirstName, LastName
INTO TestTable
FROM Person.Contact
WHERE EmailPromotion = 2
----Verify that Data in TestTable
SELECT FirstName, LastName
FROM TestTable
----Clean Up Database
DROP TABLE TestTable
GO

