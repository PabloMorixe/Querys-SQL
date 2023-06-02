USE [NOMBRE_BD]
GO



DECLARE @NOMBRE_OBJETO VARCHAR(MAX)

SET @NOMBRE_OBJETO = '[NOMBRE_OBJETO]'

SELECT OBJECT_SCHEMA_NAME(DP.major_id, db_id()), OBJECT_NAME(DP.major_id), P.name, *
FROM SYS.database_permissions DP
INNER JOIN SYS.database_principals P
ON DP.grantee_principal_id = P.principal_id
WHERE DP.major_id = OBJECT_ID('' + @NOMBRE_OBJETO + '')
