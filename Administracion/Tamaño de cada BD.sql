--SQL 2000
SELECT D.name, (SUM(F.size) * 8) / 1024
FROM SYSDATABASES D
INNER JOIN sysaltfiles F
ON D.dbid = F.dbid
WHERE D.NAME NOT IN('master', 'model', 'tempdb', 'msdb')
AND F.name NOT LIKE '%.ldf'
GROUP BY D.name
ORDER BY D.name



--SQL 2008
SELECT d.NAME
    ,ROUND(SUM(mf.size) * 8 / 1024, 0) Size_MBs
    ,(SUM(mf.size) * 8 / 1024) / 1024 AS Size_GBs
	    ,(SUM(mf.size) * 8 / 1024) / 1024 / 1024 AS Size_TBs
FROM sys.master_files mf
INNER JOIN sys.databases d ON d.database_id = mf.database_id
WHERE d.database_id > 4 -- Skip system databases
GROUP BY d.NAME
ORDER BY d.NAME