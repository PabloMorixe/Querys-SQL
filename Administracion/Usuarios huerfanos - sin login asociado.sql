--View difference in SID
USE MASTER
GO
SELECT name as SQLServerLogIn,SID as SQLServerSID FROM sys.syslogins
WHERE [name] = 'WMPROYECTO\SQL_sololectura'
GO

USE Proyecto
GO
SELECT name DataBaseID,SID as DatabaseSID FROM sysusers
WHERE [name] = 'WMPROYECTO\SQL_sololectura'
GO



--Command to generate list of orphaned users
USE adventureWorks
GO

sp_change_users_login @Action='Report'
GO




--Command to map an orphaned user
USE AdventureWorks
GO

sp_change_users_login @Action='update_one',
@UserNamePattern='TestUser1',
@LoginName='TestUser1'
GO




--Command to map an orphaned user

EXEC sp_change_users_login 'Auto_Fix', 'TestUser2'
GO




--Command to map an orphaned user to a login that is not present but will be created
EXEC sp_change_users_login 'Auto_Fix', 'TestUser3', null,'pwd'
GO