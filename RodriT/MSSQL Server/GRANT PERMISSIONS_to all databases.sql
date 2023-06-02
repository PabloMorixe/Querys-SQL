/*ASIGNA PERMISOS DE BACKUP DENEGANDO ACCESO DE ESCRITURA Y LECTURA A LOS DATOS,
A SU VES ASIGNA PERMISO DE LECTURA A DOS VISTAS PARA ACCEDER A UN REPORTE DE USUARIOS*/

Use master
GO

DECLARE @dbname VARCHAR(50)   
DECLARE @statement NVARCHAR(max)

DECLARE db_cursor CURSOR 
LOCAL FAST_FORWARD
FOR  
SELECT name
FROM MASTER.dbo.sysdatabases
WHERE name NOT IN ('master','model','msdb','tempdb','distribution','rdsadmin')  
OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @dbname  
WHILE @@FETCH_STATUS = 0  
BEGIN  

SELECT @statement = 'use '+@dbname +';
CREATE USER [svcBBDDmigra] FOR LOGIN [svcBBDDmigra];
ALTER ROLE [db_backupoperator] ADD MEMBER [svcBBDDmigra];
ALTER ROLE [db_denydatareader] ADD MEMBER [svcBBDDmigra];
ALTER ROLE [db_denydatawriter] ADD MEMBER [svcBBDDmigra];
GRANT SELECT ON [sys].[database_principals] TO [svcBBDDmigra];
GRANT SELECT ON [sys].[database_role_members] TO [svcBBDDmigra]'

--print @statement
exec sp_executesql @statement

FETCH NEXT FROM db_cursor INTO @dbname  
END  
CLOSE db_cursor  
DEALLOCATE db_cursor 