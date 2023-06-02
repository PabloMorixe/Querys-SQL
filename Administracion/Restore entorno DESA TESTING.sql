USE SAMPI
GO



sp_changedbowner 'sa', True
GO


Alter Database [SAMPI] Set AUTO_SHRINK OFF
Alter Database [SAMPI] Set RECOVERY SIMPLE
GO


DBCC SHRINKDATABASE([SAMPI])
GO


DBCC CHECKDB

sp_updatestats
GO




sp_change_users_login @Action='Report'
GO



EXEC sp_change_users_login 'Auto_Fix', 'TestUser2'
GO


EXEC sp_change_users_login 'Auto_Fix', 'TestUser3', null,'pwd'
GO


