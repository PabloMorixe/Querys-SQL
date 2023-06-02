----------------------------------------------------------------
--MONITOREO / STATUS (SQL 2000)
----------------------------------------------------------------

--Monitoreo diario
EXEC DBA_TOOLS..STP_MONITOR_DIARIO


--Configuración DDBB
EXEC DBA_TOOLS..STP_CONFIG_ALLDB_PROPERTIES


--Tamaño de archivos de BBDD
EXEC DBA_TOOLS..STP_MONITOR_DB_SIZES


--Ultimos logins creados
EXEC DBA_TOOLS..STP_MONITOR_LASTLOGINSCREATED


--Reporte de usuarios huerfanos en cada BD
EXEC DBA_TOOLS..STP_MONITOR_ORPHANED_USERS_ALLDB


--Trazas activas
EXEC DBA_TOOLS..STP_MONITOR_TRAZAS_ACTIVAS


--Logins fallidos últimos 2 días
SELECT *
FROM TRACE..TRAZAS
WHERE EVENTCLASS = 20
AND STARTTIME > GETDATE()-2
ORDER BY STARTTIME


--Ultimos accesos con Query Analyzer ó Enterprise Manager ó Sql Studio
--últimas 48 HS
SELECT *
FROM TRACE..TRAZAS
WHERE EVENTCLASS = 14 AND
        ((APPLICATIONNAME = 'SQL Query Analyzer') OR
        (APPLICATIONNAME LIKE 'MS SQLEM%') OR
        (APPLICATIONNAME LIKE 'Analizador de consultas SQL%') OR
        (APPLICATIONNAME = 'Administrador corporativo de SQL Server') OR
        (APPLICATIONNAME = 'Visual Basic') OR
        (APPLICATIONNAME LIKE 'Microsoft SQL Server %') OR
        (APPLICATIONNAME LIKE 'Microsoft_ Query'))
AND STARTTIME > getdate()-2
ORDER BY STARTTIME


--Ultimas conexiones con LINKED SERVERS
SELECT DISTINCT HOSTNAME, LOGINNAME
FROM TRACE..TRAZAS
WHERE APPLICATIONNAME = 'Microsoft SQL Server'
AND EVENTCLASS = 14
AND STARTTIME > GETDATE()-2


--Aplicaciones que accedieron durante los últimos 5 días
SELECT DISTINCT APPLICATIONNAME
FROM TRACE..TRAZAS
WHERE STARTTIME > GETDATE()-5


--Miembros de roles en Active Directory - Dominio CENTRAL
EXEC master.dbo.xp_logininfo 'CENTRAL\SQL_DBAs', 'members'
EXEC master.dbo.xp_logininfo 'CENTRAL\SQL_ARQUITECTO', 'members'
EXEC master.dbo.xp_logininfo 'CENTRAL\SQL_MANAGER_APLICACIONES', 'members'
GO
EXEC master.dbo.xp_logininfo 'CENTRAL\SQL_LIDER_CONTRALORIA', 'members'
EXEC master.dbo.xp_logininfo 'CENTRAL\SQL_LIDER_COMERCIAL', 'members'
EXEC master.dbo.xp_logininfo 'CENTRAL\SQL_LIDER_BI', 'members'
EXEC master.dbo.xp_logininfo 'CENTRAL\SQL_LIDER_AGROPECUARIO', 'members'
EXEC master.dbo.xp_logininfo 'CENTRAL\SQL_LIDER_CUENTASACOBRAR', 'members'
EXEC master.dbo.xp_logininfo 'CENTRAL\SQL_LIDER_IG', 'members'
EXEC master.dbo.xp_logininfo 'CENTRAL\SQL_LIDER_RRHH', 'members'
EXEC master.dbo.xp_logininfo 'CENTRAL\SQL_LIDER_VM', 'members'
GO
EXEC master.dbo.xp_logininfo 'CENTRAL\SQL_LIDERES_AC', 'members'
GO
EXEC master.dbo.xp_logininfo 'CENTRAL\SQL_MIDDLEWARE', 'members'
GO
EXEC master.dbo.xp_logininfo 'CENTRAL\SQL_OPERADORES', 'members'



--Monitoreo de cantidad de objetos con permisos al rol PUBLIC por cada BD
EXEC sp_msforeachdb 'USE ?;
SELECT DB_NAME() AS [Database], COUNT(*) AS [PublicPermissionCount]
FROM sysprotects P
INNER JOIN sysusers U
ON P.uid = U.uid
INNER JOIN sysobjects O
ON P.id = O.id
WHERE P.uid = 0
AND O.type <> ''S''
AND O.name NOT LIKE ''sys%''
AND O.name NOT LIKE ''sync%''
AND O.name NOT LIKE ''dt_%''
'


--Restauración de BD en los últimos 5 días
SELECT *
FROM msdb.dbo.restorehistory
WHERE restore_date > GETDATE()-5
ORDER BY restore_history_id