-----------------------------------------------------------------------
--INFO
-----------------------------------------------------------------------
EXEC sp_help
EXEC sp_help NombreObjeto

EXEC sp_helpdb
EXEC sp_helpdb NombreBD

EXEC sp_helptext NombreObjeto

EXEC sp_who
EXEC sp_who2

SELECT  SERVERPROPERTY('productversion'), SERVERPROPERTY ('productlevel'), SERVERPROPERTY ('edition')




-----------------------------------------------------------------------
--Conocer el estado de una BD
-----------------------------------------------------------------------
DECLARE @DB VARCHAR(MAX)

SET @DB = 'Proyecto'

SELECT databaseproperty(@DB, 'IsShutDown') AS IsShutDown
	,databaseproperty(@DB, 'IsEmergencyMode') AS IsEmergencyMode
	,databaseproperty(@DB, 'IsSingleUser') AS IsSingleUser
	,databaseproperty(@DB, 'IsDboOnly') AS IsDboOnly
	,databaseproperty(@DB, 'IsReadOnly') AS IsReadyOnly
	,databaseproperty(@DB, 'IsOffline') AS IsOffline
	,databaseproperty(@DB, 'IsSuspect') AS IsSuspect
	,databaseproperty(@DB, 'IsInLoad') AS IsInLoad
	,databaseproperty(@DB, 'IsInRecovery') AS IsInRecovery
	,databaseproperty(@DB, 'IsNotRecovered') AS IsNotRecovered




-----------------------------------------------------------------------
--SET Online / Ofline database
-----------------------------------------------------------------------
ALTER DATABASE [base de datos] SET OFFLINE
ALTER DATABASE [base de datos] SET ONLINE




-----------------------------------------------------------------------
--Conocer el Recovery Model de una BD
-----------------------------------------------------------------------
SELECT DATABASEPROPERTYEX ('BD', 'Recovery')



-----------------------------------------------------------------------
--Logins
-----------------------------------------------------------------------
ALTER LOGIN [nombre_login] DISABLE
GO
ALTER LOGIN [nombre_login] ENABLE
GO


-----------------------------------------------------------------------
--Usuarios en SQL 2000
-----------------------------------------------------------------------
EXEC sp_denylogin 'exampleuser' 
or

EXEC sp_revokelogin 'exampleuser' 


EXEC sp_grantlogin 'exampleuser' 



-----------------------------------------------------------------------
--SET Single User
-----------------------------------------------------------------------
ALTER DATABASE [Test4] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
OR
ALTER DATABASE [Test4] SET SINGLE_USER WITH ROLLBACK AFTER 30
OR
ALTER DATABASE [Test4] SET SINGLE_USER WITH NO_WAIT



ALTER DATABASE Proyecto SET MULTI_USER


-----------------------------------------------------------------------
--Renombrar una BD
-----------------------------------------------------------------------
USE master
GO
EXEC sp_dboption DevelopmentDB, 'Single User', True
EXEC sp_renamedb 'DevelopmentDB', 'ProductionDB'
EXEC sp_dboption ProductionDB, 'Single User', False

/* CUIDADO: Los nombres de archivos físicos de BD no se modifican, quedan igual */




-----------------------------------------------------------------------
--Crear un Login
-----------------------------------------------------------------------
CREATE LOGIN [MIAMI\SalesUser] FROM Windows
CREATE LOGIN [MIAMI\HREmployees] FROM WINDOWS WITH DEFAULT_DATABASE=[AdventureWorks]
CREATE LOGIN [HRAppAdmin] WITH PASSWORD=N'Pa$$w0rd', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO
EXEC master..sp_addsrvrolemember @loginame = N'MIAMI\ITEmployees', @rolename = N'dbcreator'
GO




-----------------------------------------------------------------------
--Crear un usuario de BD
-----------------------------------------------------------------------
CREATE USER [SalesUser] FROM LOGIN [MIAMI\SalesUser]
CREATE USER [Holly] FOR LOGIN [MIAMI\Holly] WITH DEFAULT_SCHEMA=[HumanResources]
GO
EXEC sp_addrolemember N'db_backupoperator', N'Anders'
EXEC sp_addrolemember N'db_datareader', N'HRApp'
GO




-----------------------------------------------------------------------
--Impersonalización
-----------------------------------------------------------------------
-- Impersonate a user to test permissions
EXECUTE AS USER = 'Holly'
GO
-- Return to the default security context
REVERT





-----------------------------------------------------------------------
--Tareas de mantenimiento
-----------------------------------------------------------------------
UPDATE STATISTICS Proyecto.dbo.Articulo
GO



-----------------------------------------------------------------------
--Comandos DBCC
-----------------------------------------------------------------------
DBCC CHECKDB
DBCC CHECKALLOC
DBCC CHECKCATALOG
DBCC CHECKCONSTRAINTS
DBCC CHECKIDENT('NombreTabla')
DBCC CHECKTABLE('Vendedor')
DBCC SHRINKDATABASE('Proyecto')



-----------------------------------------------------------------------
--Cantidad de registros en cada tabla de una BD
-----------------------------------------------------------------------
SELECT 
    [TableName] = so.name, 
    [RowCount] = MAX(si.rows) 
FROM 
    sysobjects so, 
    sysindexes si 
WHERE 
    so.xtype = 'U' 
    AND 
    si.id = OBJECT_ID(so.name) 
GROUP BY 
    so.name 
ORDER BY 
    1
	
	
	
	
-----------------------------------------------------------------------
--Cambiar el Owner de un DTS
-----------------------------------------------------------------------
EXEC msdb..sp_reassign_dtspackageowner 'DTS BACKUP Diario', null, 'CENTRAL\Administrator'




-----------------------------------------------------------------------
--Cambiar el Owner de una BD (Solucionar Login asociado a usuario de BD "dbo" incorrecto)
-----------------------------------------------------------------------
USE BD
GO

sp_changedbowner 'sa', True



-----------------------------------------------------------------------
--Establecer un Stored Procedure para autoejecutarse al iniciar el servicio del motor SQL
-----------------------------------------------------------------------
USE master
GO

sp_procoption [ @ProcName = ] 'procedure' 
    , [ @OptionName = ] 'option' 
    , [ @OptionValue = ] 'value' 

	
-----------------------------------------------------------------------
--Fragmentacion en Indices
-----------------------------------------------------------------------
<= 5% - Do nothing
>5 and <= 30% - Reorganize (defrag)
>30% - Rebuild



-----------------------------------------------------------------------
--Asignar permiso a BD y DATAREADER en todas las bases para un login SQL Existente
-----------------------------------------------------------------------
sp_msforeachdb 'USE ?; EXEC sp_grantdbaccess N''SOPORTE_FOCUS_DWOJTIUK'', N''SOPORTE_FOCUS_DWOJTIUK'''
sp_msforeachdb 'USE ?; EXEC sp_addrolemember N''db_datareader'', N''SOPORTE_FOCUS_DWOJTIUK'''


-----------------------------------------------------------------------
--Quitar permisos en rol DATAREADER y BD para un login SQL
-----------------------------------------------------------------------
sp_msforeachdb 'USE ?; EXEC sp_droprolemember ''db_datareader'', N''SOPORTE_FOCUS_CSMERIGLINO'''
sp_msforeachdb 'USE ?; EXEC sp_revokedbaccess ''SOPORTE_FOCUS_CSMERIGLINO'''