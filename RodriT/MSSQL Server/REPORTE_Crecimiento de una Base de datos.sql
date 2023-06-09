SET NOCOUNT ON
/*
Author:	Nicholas Williams
Date:	3rd February 2008
Desc:		Calculates
nfo for all databases on a server that are being backed up. Relies on the backup tables, and as a result will only contain as many
		days history as do the backup tables(@iNoSamples). If a database is not being backup up the results will be NULL. (For example the Tempdb)
		This is a rewrite of something I did a few years ago, as I dont know where I saved the other code. bummer.
Email:	Nicholas.Williams@reagola.com		
*/

CREATE TABLE ##tbl_DataSize
		(
		Size	DECIMAL(20)
		)

CREATE TABLE #tbl_GrowthData
		(
		 DatabaseName					VARCHAR(50)
		,NoSampleDays					DECIMAL(20,3)
		,DataSizeMB					DECIMAL(20,3)
		,LogSizeMB					DECIMAL(20,3)
		,BackupSizeMB					DECIMAL(20,3)
		,TotalSpaceMB					DECIMAL(20,3)
		,DataGrowth					DECIMAL(20,3)
		,LogGrowth					DECIMAL(20,3)
		,GrowthPercentage				DECIMAL(20,3)
		)

DECLARE 
	 @iNoSamples		INT
	,@nMaxBackupSize	DECIMAL
	,@nMinBackupSize	DECIMAL
	,@nMaxLogSize		DECIMAL
	,@nMinLogSize		DECIMAL
	,@nMaxDataSize		DECIMAL
	,@nMinDataSize		DECIMAL
	,@vcDatabaseName	VARCHAR(50)
	,@dtMaxBackupTime	DATETIME
	,@dtMinBackupTime	DATETIME
	,@iMinBackupID		INT
	,@iMaxBackupID		INT
	
DECLARE file_cursor CURSOR FOR
SELECT [name] FROM master.dbo.sysdatabases
ORDER BY [name]
OPEN file_cursor

   FETCH NEXT FROM file_cursor
   INTO @vcDatabaseName

WHILE @@FETCH_STATUS = 0
BEGIN  

SET @dtMaxBackupTime = (SELECT MAX(backup_finish_date)FROM msdb.dbo.backupset WHERE database_name = @vcDatabaseName AND [type] = 'D')
SET @dtMinBackupTime = (SELECT MIN(backup_finish_date)FROM msdb.dbo.backupset WHERE database_name = @vcDatabaseName AND [type] = 'D')
SET @iNoSamples =	
	DATEDIFF 
		( 
		  dd
		 ,@dtMinBackupTime
		 ,@dtMaxBackupTime
		)

SET @nMaxBackupSize	= (SELECT backup_size FROM msdb.dbo.backupset WHERE database_name = @vcDatabaseName AND [type] = 'D' AND backup_finish_date = @dtMaxBackupTime)
SET @nMinBackupSize	= (SELECT backup_size FROM msdb.dbo.backupset WHERE database_name = @vcDatabaseName AND [type] = 'D' AND backup_finish_date = @dtMinBackupTime)

SET @iMaxBackupID	= (SELECT MAX(backup_set_id) FROM msdb.dbo.backupset WHERE database_name = @vcDatabaseName AND [type] = 'D' AND backup_finish_date = @dtMaxBackupTime)
SET @iMinBackupID	= (SELECT MAX(backup_set_id) FROM msdb.dbo.backupset WHERE database_name = @vcDatabaseName AND [type] = 'D' AND backup_finish_date = @dtMinBackupTime)

SET @nMaxLogSize	= (SELECT ((CAST((SUM(file_size)) AS DECIMAL(20,3))) /  1048576) FROM msdb.dbo.backupfile	WHERE backup_set_id = @iMaxBackupID AND file_type = 'L')
SET @nMinLogSize	= (SELECT ((CAST((SUM(file_size)) AS DECIMAL(20,3))) /  1048576) FROM msdb.dbo.backupfile	WHERE backup_set_id = @iMinBackupID AND file_type = 'L')
SET @nMaxDataSize	= (SELECT ((CAST((SUM(file_size)) AS DECIMAL(20,3))) /  1048576) FROM msdb.dbo.backupfile	WHERE backup_set_id = @iMaxBackupID AND file_type = 'D')
SET @nMinDataSize	= (SELECT ((CAST((SUM(file_size)) AS DECIMAL(20,3))) /  1048576) FROM msdb.dbo.backupfile	WHERE backup_set_id = @iMinBackupID AND file_type = 'D')

EXEC ('
INSERT INTO ##tbl_DataSize
SELECT CAST((SUM(size)) as DECIMAL(20,3)) FROM '+@vcDatabaseName+'.dbo.sysfiles'
)

INSERT INTO #tbl_GrowthData
SELECT 
	 @vcDatabaseName DatabaseName
	,@iNoSamples NoSampleDays
	,@nMaxDataSize
	,@nMaxLogSize
	,@nMaxBackupSize / 1048576
	,((size * 8192) / 1048576) TotalSpaceUsed  
	,@nMaxDataSize - @nMinDataSize
	,@nMaxLogSize  - @nMinLogSize
	,(((@nMaxDataSize + @nMaxLogSize) - (@nMinDataSize+ @nMinLogSize)) / (@nMinDataSize+ @nMinLogSize)) * 100.00
	--growth percentage is calculated based upon the original data size, before the growth. as a result it may look a little funny, but it is accurate. or at least I think so :)
FROM ##tbl_DataSize

	TRUNCATE TABLE ##tbl_DataSize

   FETCH NEXT FROM file_cursor
   INTO @vcDatabaseName

END
CLOSE file_cursor
DEALLOCATE file_cursor

SELECT 
	*
FROM #tbl_GrowthData
where DatabaseName ='SOA'

DROP TABLE ##tbl_DataSize
DROP TABLE #tbl_GrowthData

SET NOCOUNT OFF
