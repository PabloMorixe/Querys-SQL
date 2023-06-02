/*********************************************************************************************************************
** Creation Date: Long time ago ?
** Modif Date	: Nov. 27, 2002
** Created By	: avigneau
** Database	: any	
** Description  : Reports on all indexes on user tables within a database
		  Reports Tables with Missing Clustered index
		  Reports Tables with Missing Primary Keys
		  Reports Possible Redundant Index keys
		  Reports Possible Reverse Index key

** Parameters   : none

** Compatibility: SQL Server 6.X, 7.0, 2000
** Remark	: System tables are used to be compatible with version 6.x.
		  But I beleive it would still be difficult to obtain the same results 
		  using INFORMATION_SCHEMA views and new object and system property functions.
		  
** Example	: Run as a batch
**********************************************************************************************************************/

CREATE VIEW dbo.INDEXVIEW
AS
/*********************************************************************************************************************
** Creation Date: ?
** Modif Date	: Nov. 27, 2002
** Created By	: avigneau
** Database	: any	
** Description  : Reports on all indexes and / or heaps on user tables within a database

** Parameters   : none

** Compatibility: SQL Server 6.X, 7.0, 2000
** Remark	: System tables are used to be compatible with version 6.x.
		  But I beleive it would still be difficult to obtain the same results 
		  using INFORMATION_SCHEMA views and new object and system property functions.
		  
** Example	: SELECT 'Showing All Indexes' AS Comments, I.*
		  FROM dbo.INDEXVIEW I
		
		  SELECT 'Showing Tables with Missing Clustered index' AS Comments, I.*
		  FROM dbo.INDEXVIEW I
		  WHERE ClusterType = 'HEAP'
		
		  SELECT 'Showing Tables with Missing Primary Keys' AS Comments,  I.*
		  FROM dbo.INDEXVIEW I
		  LEFT OUTER JOIN dbo.INDEXVIEW I2
		  ON I.TableID = I2.TableID AND I2.UniqueType = 'PRIMARY KEY'
		  WHERE I2.TableID IS NULL
		
		  SELECT 'Showing Possible Redundant Index keys' AS Comments,  I.*
		  FROM dbo.INDEXVIEW I
		  JOIN dbo.INDEXVIEW I2
		  ON I.TableID = I2.TableID AND I.ColName1 = I2.ColName1 AND I.IndexName <> I2.IndexName
		
		  SELECT 'Showing Possible Reverse Index keys' AS Comments,  I.*
		  FROM dbo.INDEXVIEW I
		  JOIN dbo.INDEXVIEW I2
		  ON I.TableID = I2.TableID AND I.ColName1 = I2.ColName2 AND I.ColName2 = I2.ColName1 AND I.IndexName <> I2.IndexName
**********************************************************************************************************************/
SELECT o.id AS TableID,u.name Owner,o.name TableName,
	       i.Indid AS IndexID, CASE i.name WHEN o.name THEN '** NONE **' ELSE i.name END AS IndexName, 
	       CASE i.indid WHEN 1 THEN 'CLUSTERED' WHEN 0 THEN 'HEAP' ELSE 'NONCLUSTERED' END AS ClusterType,
	       CASE	WHEN (i.status & 2048) > 0 THEN 'PRIMARY KEY' WHEN (i.status & (2|4096)) > 0 THEN 'UNIQUE' ELSE ' ' END AS UniqueType,
	       CASE	WHEN (i.status & (2048)) > 0 OR ((i.status & (4096)) > 0 ) THEN 'CONSTRAINT' WHEN i.indid = 0 THEN ' ' ELSE 'INDEX' END AS IndexType,
-- This following part is non essential
-- It is a pre char aggregate I use in other scripts 
-- to generate create and drop scripts
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 1) IS NULL THEN '' ELSE INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 1) END +
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 2) IS NULL THEN '' ELSE ', '+INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 2) END +
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 3) IS NULL THEN '' ELSE ', '+INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 3) END +
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 4) IS NULL THEN '' ELSE ', '+INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 4) END +
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 5) IS NULL THEN '' ELSE ', '+INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 5) END +
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 6) IS NULL THEN '' ELSE ', '+INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 6) END +
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 7) IS NULL THEN '' ELSE ', '+INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 7) END +
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 8) IS NULL THEN '' ELSE ', '+INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 8) END +
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 9) IS NULL THEN '' ELSE ', '+INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 9) END +
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 10) IS NULL THEN '' ELSE ', '+INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 10) END +
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 11) IS NULL THEN '' ELSE ', '+INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 11) END +
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 12) IS NULL THEN '' ELSE ', '+INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 12) END +
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 13) IS NULL THEN '' ELSE ', '+INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 13) END +
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 14) IS NULL THEN '' ELSE ', '+INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 14) END +
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 15) IS NULL THEN '' ELSE ', '+INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 15) END +
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 16) IS NULL THEN '' ELSE ', '+INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 16) END AS AllColName,
-- 
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 1) IS NULL THEN '' ELSE INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 1) END  AS ColName1,
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 2) IS NULL THEN '' ELSE INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 2) END AS ColName2,
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 3) IS NULL THEN '' ELSE INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 3) END AS ColName3,
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 4) IS NULL THEN '' ELSE INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 4) END AS ColName4,
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 5) IS NULL THEN '' ELSE INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 5) END AS ColName5,
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 6) IS NULL THEN '' ELSE INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 6) END AS ColName6,
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 7) IS NULL THEN '' ELSE INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 7) END AS ColName7,
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 8) IS NULL THEN '' ELSE INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 8) END AS ColName8,
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 9) IS NULL THEN '' ELSE INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 9) END AS ColName9,
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 10) IS NULL THEN '' ELSE INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 10) END AS ColName10,
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 11) IS NULL THEN '' ELSE INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 11) END AS ColName11,
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 12) IS NULL THEN '' ELSE INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 12) END AS ColName12,
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 13) IS NULL THEN '' ELSE INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 13) END AS ColName13,
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 14) IS NULL THEN '' ELSE INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 14) END AS ColName14,
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 15) IS NULL THEN '' ELSE INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 15) END AS ColName15,
	       CASE	WHEN INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 16) IS NULL THEN '' ELSE INDEX_COL(u.name+'.'+QUOTENAME(o.name), i.indid, 16) END AS ColName16
	FROM sysobjects o  (NOLOCK)
	LEFT OUTER JOIN sysindexes i (NOLOCK) ON o.id = i.id
	JOIN sysusers u  (NOLOCK) ON o.uid = u.uid
	WHERE o.type = 'U' AND i.indid < 255
	AND o.name NOT IN ('dtproperties') AND i.name NOT LIKE '_WA_Sys_%' -- because of SQL Server 7.0
GO


SELECT 'Showing All Indexes' AS Comments, I.*
FROM dbo.INDEXVIEW I
GO

SELECT 'Showing Tables with Missing Clustered index' AS Comments, I.*
FROM dbo.INDEXVIEW I
WHERE ClusterType = 'HEAP'
GO

SELECT 'Showing Tables with Missing Primary Keys' AS Comments,  I.*
FROM dbo.INDEXVIEW I
LEFT OUTER JOIN dbo.INDEXVIEW I2
ON I.TableID = I2.TableID AND I2.UniqueType = 'PRIMARY KEY'
WHERE I2.TableID IS NULL
GO

SELECT 'Showing Possible Redundant Index keys' AS Comments,  I.*
FROM dbo.INDEXVIEW I
JOIN dbo.INDEXVIEW I2
ON I.TableID = I2.TableID AND I.ColName1 = I2.ColName1 AND I.IndexName <> I2.IndexName
ORDER BY I.TableName,I.IndexName
GO

SELECT 'Showing Possible Reverse Index keys' AS Comments,  I.*
FROM dbo.INDEXVIEW I
JOIN dbo.INDEXVIEW I2
ON I.TableID = I2.TableID AND I.ColName1 = I2.ColName2 AND I.ColName2 = I2.ColName1 
AND I.IndexName <> I2.IndexName
GO

DROP VIEW INDEXVIEW
GO