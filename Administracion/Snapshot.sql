--CREACI�N DE UN SNAPSHOT A PARTIR DE UNA BD
CREATE DATABASE EFRAMEWORK_SNAPSHOT ON
(Name ='EFRAMEWORK_Data',
FileName='V:\Data\EFRAMEWORK_SNAPSHOT.ss')
AS SNAPSHOT OF EFRAMEWORK;
GO



--RESTAURACION DE UNA BD A PARTIR DE UN SNAPSHOT
RESTORE DATABASE EFRAMEWORK
FROM DATABASE_SNAPSHOT = 'EFRAMEWORK_SNAPSHOT';



--DROPEADO DE UN SNAPSHOT
DROP DATABASE EFRAMEWORK_SNAPSHOT