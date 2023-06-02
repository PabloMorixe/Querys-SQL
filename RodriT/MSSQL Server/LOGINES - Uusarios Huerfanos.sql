DECLARE @DBname sysname
DECLARE @sqlCMD nvarchar(max)

CREATE TABLE #temp_usersinlogin
( [UserSinLogin] sysname null, [BaseDeDatos] sysname null )

CREATE TABLE #temp_loginsinuser
( [LoginSinUser] sysname null )

INSERT INTO #temp_loginsinuser
SELECT [name]
FROM master.sys.server_principals
WHERE [principal_id] > 10
  AND [name] not like '##%'
  AND [name] not like 'NT AUTHORITY\%'
  AND [name] not like 'NT SERVICE\%'

DECLARE cursor_db CURSOR LOCAL FAST_FORWARD FOR
SELECT [name]
FROM master.sys.databases
WHERE [state_desc] = 'ONLINE'
  AND [name] not in ('master','model','tempdb','msdb','distribution')

OPEN cursor_db
FETCH NEXT FROM cursor_db INTO @DBname

WHILE (@@FETCH_STATUS = 0)
BEGIN
  -- USERS SIN LOGIN
  SET @sqlCMD = 'INSERT INTO #temp_usersinlogin
                 SELECT [name],
                        '''+@DBname+'''
                 FROM ['+@DBname+'].sys.database_principals
                 WHERE [sid] not in ( select [sid] from master.sys.server_principals )
                   AND [type] <> ''R''
                   AND [is_fixed_role] = 0
                   AND [principal_id] > 4'
  EXECUTE(@sqlCMD)
  
  -- LOGIN SIN USERS
  SET @sqlCMD = 'DELETE FROM #temp_loginsinuser
                 WHERE [LoginSinUser] in ( select [name] COLLATE SQL_Latin1_General_CP1_CI_AS from ['+@DBname+'].sys.database_principals )'
  EXECUTE(@sqlCMD)
  
  FETCH NEXT FROM cursor_db INTO @DBname
END

SELECT [UserSinLogin], [BaseDeDatos]
FROM #temp_usersinlogin
ORDER BY [BaseDeDatos], [UserSinLogin]

SELECT [LoginSinUser]
FROM #temp_loginsinuser
ORDER BY [LoginSinUser]

DROP TABLE #temp_usersinlogin
DROP TABLE #temp_loginsinuser
