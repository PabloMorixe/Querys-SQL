--SQL 2008
USE PJC
GO


declare @RoleName varchar(50) = 'ROL_INTEGRACION'
declare @Script varchar(max) = 'CREATE ROLE ' + @RoleName + char(13) 



select @script = @script + 'GRANT ' + prm.permission_name + ' ON ' + 
OBJECT_NAME(major_id) + ' TO ' + rol.name + char(13) COLLATE Latin1_General_CI_AS  
from sys.database_permissions prm     
join sys.database_principals rol 
on prm.grantee_principal_id = rol.principal_id 
where rol.name = @RoleName  



print @script






--SQL 2000
--alter PROCEDURE Sp_Script_Rol
--@ROL_NAME varchar(30)
DECLARE @ROL_NAME varchar(30);
SET @ROL_NAME  = 'ROL_INTEGRACION';
--AS
BEGIN
SELECT CASE protecttype
        WHEN '205' THEN 'GRANT '
        WHEN '206' THEN 'DENY '
        END +
        CASE action 
        WHEN '193' THEN 'SELECT ' 
        WHEN '195' THEN 'INSERT '
        WHEN '196' THEN 'DELETE '
        WHEN '197' THEN 'UPDATE '
        WHEN '224' THEN 'EXECUTE '
        WHEN  '26' THEN 'REFERENCES '
        END +
        'ON ' + name + ' TO ' + @ROL_NAME
FROM [dbo].[sysprotects]
INNER JOIN [dbo].[sysobjects]
ON [sysprotects].[id] = [sysobjects].[id]
WHERE [sysprotects].[uid] = (SELECT uid
FROM DBO.SYSUSERS
WHERE UID IN 
(SELECT groupuid
FROM DBO.SYSMEMBERS)
AND name = @ROL_NAME)
 
END;