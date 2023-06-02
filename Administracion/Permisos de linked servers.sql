--ELIMINAR UN USUARIO DE LINKED SERVER
USE [master]
GO
EXEC master.dbo.sp_droplinkedsrvlogin 
@rmtsrvname = N'BIRCOS_2_LOGISTICA_BIZNAGA', 
@locallogin = N'CENTRAL\OSGOMEZ'




--CONSULTAR LINKED SERVERS A PARTIR DE UN LOGIN
SELECT S.name, *
FROM sys.linked_logins LL
INNER JOIN sys.servers S
ON LL.server_id = S.server_id
INNER JOIN sys.server_principals SP
ON LL.local_principal_id = SP.principal_id
WHERE SP.name LIKE '%osgomez%'
ORDER BY S.name ASC