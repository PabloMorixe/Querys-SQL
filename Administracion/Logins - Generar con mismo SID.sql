SELECT 'CREATE LOGIN [' + name + '] WITH PASSWORD=''pass'', SID=' + master.dbo.fn_varbintohexstr(sid) + ', DEFAULT_DATABASE=[' + default_database_name + '], DEFAULT_LANGUAGE=[' + default_language_name + '], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO'
FROM sys.server_principals
WHERE type = 'S'
AND name NOT IN('sa', 'LedesmaSystemAdministrator', 'EMERGENCIA', 'DBA')
AND name NOT LIKE '%MS_Policy%'
ORDER BY name