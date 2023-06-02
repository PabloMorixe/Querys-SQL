DECLARE @dbname VARCHAR(MAX);


DECLARE CURSOR_DB CURSOR
LOCAL FAST_FORWARD
	FOR SELECT name
		  FROM sys.databases 
		 WHERE name <> 'master' 
		   AND name <> 'model' 
		   AND name <> 'msdb' 
		   AND name <> 'tempdb'
		   AND source_database_id IS NULL --Sólo BD, sin snapshots
	  ORDER BY name ASC;
			
			
OPEN CURSOR_DB;

FETCH NEXT FROM CURSOR_DB
INTO @dbname;
	
WHILE @@FETCH_STATUS = 0
BEGIN
			
	
	--PRINT @dbname
	
	
	--loop next db
	FETCH NEXT FROM CURSOR_DB
	INTO @dbname;
	
END

--close cursor
CLOSE CURSOR_DB
DEALLOCATE CURSOR_DB
